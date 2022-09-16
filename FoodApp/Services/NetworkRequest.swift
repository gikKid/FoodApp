import Foundation

enum NetworkError:Error {
    case invalidData
}

protocol NetworkRequest:AnyObject {
    associatedtype ModelType
    func decode(_ data:Data) -> ModelType?
    func execute(withCompletion completion: @escaping (ModelType?,Error?) -> Void)
}

extension NetworkRequest {
       func load(_ url:URL, withCompletion completion: @escaping (ModelType?,Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) {  (data, _, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil,error)
                }
                return
            }
            guard let data = data, let value = self.decode(data) else {
                DispatchQueue.main.async {
                    completion(nil,NetworkError.invalidData)
                }
                return
            }
            DispatchQueue.main.async {
                completion(value,nil)
            }
        }
        task.resume()
    }
}

