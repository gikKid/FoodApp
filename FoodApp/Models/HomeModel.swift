import Foundation

// MARK: - Category
struct Category:Decodable {

    let strCategory: String
    let image: String
    
    private enum CodingKeys:String, CodingKey {
        case image = "strCategoryThumb"
        case strCategory
    }
}


struct Meals:Decodable {
    let meals:[Meal]
}


// MARK: - Meal
struct Meal: Decodable {
    let strMeal: String
    let image: String
    
    private enum CodingKeys:String, CodingKey {
        case image = "strMealThumb"
        case strMeal
    }
}

//MARK: - Wrapper
struct WrapperCategories<T:Decodable>: Decodable {
    let categories: [T]
}
