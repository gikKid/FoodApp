import Foundation

final class ApiMealRequest<Resource:APIResource> {
    let resource:Resource
    
    init(resource:Resource) {
        self.resource = resource
        
    }
}

extension ApiMealRequest:NetworkRequest {
    
    func decode(_ data: Data) -> [Resource.ModelType]? {
        let decoder = JSONDecoder()
        var wrapper:[Resource.ModelType]?
        decoder.dateDecodingStrategy = .secondsSince1970
        do {
            let results = try decoder.decode(WrapperMeals<Resource.ModelType>.self, from: data)
            wrapper = results.meals
        } catch {
            print(error)
        }
        return wrapper
    }
    
    func execute(withCompletion completion: @escaping ([Resource.ModelType]?, Error?) -> Void) {
        self.load(resource.url, withCompletion: completion)
    }
    
}
