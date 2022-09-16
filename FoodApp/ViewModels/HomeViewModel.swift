import Foundation
import UIKit

struct CellViewModel {
    var name: String
    var image:String
}


final class HomeViewModel: NSObject {
    var reloadCollectionView: (() -> Void)?
    var categories = [Category]()
    var meals = [Meal]()
    var categoryCellViewModels = [CellViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }
    var recommendedMealCellViewModels = [CellViewModel]() {
        didSet {
            //reloadCollectionView?()
        }
    }
    
    
    //MARK: - Category collection UI setup
    public func numberOfSections() -> Int {
        1
    }
    
    public func didSelectCategoryItemAt(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = categoryCellViewModels[indexPath.row]
        self.getRecommendedMeal(meal: meal.name)
        
    }
    
    public func setupCategoryCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identefier, for: indexPath) as? CategoryCollectionViewCell else {
            fatalError()
        }
        let cellViewModel = self.getCategoryCellViewModel(at: indexPath)
        cell.cellViewModel = cellViewModel
        return cell
    }
    
    public func setupCategoryCellSize() -> CGSize {
        CGSize(width: 85, height: 115)
    }
    
    public func getCategories() {
        
        let categoryResource = CategoryResource()
        
        let  apiRequest = ApiCategoriesRequest(resource: categoryResource)
        apiRequest.execute(withCompletion: {[weak self] (categories,error) in
            guard let categories = categories else {return}
            self?.fetchCategoriesData(categories: categories)
        })
        
    }
    
    private func getRecommendedMeal(meal:String) {
        let mealResource = MealResource(meal: meal)
        
        let apiRequest = ApiMealRequest(resource: mealResource)
        apiRequest.execute(withCompletion: { meals, error in
            guard let meals = meals else {return}
            print(meals)
            self.fetchMealsData(meals: meals)
        })
    }
    
    private func fetchMealsData(meals:[Meal]) {
        self.meals = meals
        var vms = [CellViewModel]()
        
        for meal in meals {
            vms.append(CellViewModel(name: meal.strMeal, image: meal.image))
        }
        self.recommendedMealCellViewModels = vms
    }
    
    
    private func fetchCategoriesData(categories: [Category]) {
        self.categories = categories // Cache
        
        var vms = [CellViewModel]()
        
        for category in categories {
            vms.append(CellViewModel(name: category.strCategory, image: category.image))
        }
        categoryCellViewModels = vms
    }
    
    
    private func getCategoryCellViewModel(at indexPath: IndexPath) -> CellViewModel {
        return categoryCellViewModels[indexPath.row]
    }
    
    
}
