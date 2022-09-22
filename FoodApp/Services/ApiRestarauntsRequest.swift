import Foundation

final class ApiRestarauntsRequest<Resource:RestarauntsAPIResource> {
    let resource:Resource
    
    init(resource:Resource) {
        self.resource = resource
    }
}

extension ApiRestarauntsRequest:NetworkRequest {
    
    func decode(_ data: Data) -> [Resource.ModelType]? {
        let decoder = JSONDecoder()
        var wrapper:[Resource.ModelType]?
        do {
            let results = try decoder.decode(WrapperRestaraunts<Resource.ModelType>.self, from: data)
            wrapper = results.items
        } catch {
            print(error)
        }
        return wrapper
    }
    
    func execute(withCompletion completion: @escaping ([Resource.ModelType]?, Error?) -> Void) {
        self.load(resource.url, withCompletion: completion)
    }
    
    
}
