import Foundation

final class ApiCategoriesRequest<Resource:APIResource> {
    let resource:Resource
    
    init(resource:Resource) {
        self.resource = resource
    }
}

extension ApiCategoriesRequest:NetworkRequest {
    func decode(_ data: Data) -> [Resource.ModelType]? {
        let decoder = JSONDecoder()
        var wrapper:[Resource.ModelType]?
        decoder.dateDecodingStrategy = .secondsSince1970
        do {
            let results = try decoder.decode(WrapperCategories<Resource.ModelType>.self, from: data)
            wrapper = results.categories
        }
        catch {
            print(error)
        }
        return wrapper
    }
    
    func execute(withCompletion completion: @escaping ([Resource.ModelType]?,Error?) -> Void) {
        self.load(resource.url, withCompletion: completion)
    }
}
