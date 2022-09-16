import Foundation

struct MealResource:APIResource {
    var meal:String
    
    var methodPath: String {
        return "/filter.php?c=\(meal)"
    }
    
    typealias ModelType = Meal
}
