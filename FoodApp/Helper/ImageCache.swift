import Foundation
import UIKit

protocol ImageCacheType:class {
    func image(for url:URL) -> UIImage?
    func insertImage(_ image:UIImage?,for url:URL)
    func removeImage(for url:URL)
    subscript(_ url:URL) -> UIImage? {get set}
}

final class ImageCache {
    
    static let shared = ImageCache()
    
    private lazy var imageCache:NSCache<AnyObject,AnyObject> = { // cache содержащий закодированные изображения
       let cache = NSCache<AnyObject,AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    
    private lazy var decodedImageCache:NSCache<AnyObject,AnyObject> = {
        let cache = NSCache<AnyObject,AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    
    private let lock = NSLock()
    private let config:Config
    
    
    struct Config {
        let countLimit:Int
        let memoryLimit:Int
        
        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }
    
    
    private init(config:Config = Config.defaultConfig) {
        self.config = config
    }
}

extension ImageCache:ImageCacheType {
    func removeImage(for url: URL) {
        lock.lock(); defer {
            lock.unlock()
        }
        
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }
    
    func image(for url: URL) -> UIImage? {
        lock.lock(); defer {
            lock.unlock()
        }
         
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject,cost: decodedImage.pngData()!.count)
            return decodedImage
        }
        return nil
        
    }
    
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else {return removeImage(for: url)}
        let decodedImage = image.decodedImage()
        
        lock.lock(); defer {
            lock.unlock()
        }
        imageCache.setObject(decodedImage, forKey: url as AnyObject)
        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject,cost: decodedImage.pngData()!.count)
    }
    
    subscript(url: URL) -> UIImage? {
        get {
            return image(for: url)
        }
        set {
            return insertImage(newValue, for: url)
        }
    }
    
    
}
