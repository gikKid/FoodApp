import Foundation

struct CategoryResource:APIResource {
    var methodPath: String {
        return "/categories.php"
    }
    
    typealias ModelType = Category
}
