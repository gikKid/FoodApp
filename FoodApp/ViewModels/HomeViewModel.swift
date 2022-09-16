import Foundation

struct CategoryCellViewModel {
    var name: String
    var image:String
}

class HomeViewModel: NSObject {
    var reloadCollectionView: (() -> Void)?
    var categories = [Category]()
    var categoryCellViewModels = [CategoryCellViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }
    
    
    func getCategories() {
        
        let categoryResource = CategoryResource()
        
        let  apiRequest = ApiCategoriesRequest(resource: categoryResource)

        apiRequest.execute(withCompletion: {[weak self] (categories,error) in
            guard let categories = categories else {return}
            self?.fetchCategoriesData(categories: categories)
        })
        
    }
    
    
    
    func fetchCategoriesData(categories: [Category]) {
        self.categories = categories // Cache
        
        var vms = [CategoryCellViewModel]()
        
        for category in categories {
            vms.append(createCategoryCellModel(category: category))
        }
        categoryCellViewModels = vms
    }
    
    func createCategoryCellModel(category: Category) -> CategoryCellViewModel {
        let name = category.strCategory
        let image = category.image
        return CategoryCellViewModel(name: name, image: image)
    }
    
    func getCategoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel {
        return categoryCellViewModels[indexPath.row]
    }
    
    
    
}
