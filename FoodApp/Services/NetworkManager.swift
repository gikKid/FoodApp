import Foundation

protocol NetworkManagerProtocol {
    
    func getCategories(completion: @escaping (_ success: Bool, _ results: Categories?, _ error: String?) -> ())
    
}


final class NetworkManger: NetworkManagerProtocol {
    
    static let shared = NetworkManger()
    
    private init() {}
    
    private struct Constant {
        static let categoriesLink = "https://www.themealdb.com/api/json/v1/1/categories.php"
    }
    
     func getCategories(completion: @escaping (Bool, Categories?, String?) -> ()) {
        
        HttpRequestHelper().GET(url: Constant.categoriesLink, params: ["": ""], httpHeader: .application_json) { success, data in
            
            if success {
                do {
                    let model = try JSONDecoder().decode(Categories.self, from: data!)
                    completion(true, model, nil) }
                    
                catch { completion(false, nil, "Error: Trying to parse Employees to model")
                }
            } else {
                completion(false, nil, "Error: Employees GET Request failed")
            }
        }
    }
}
