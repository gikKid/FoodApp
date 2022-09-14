import Foundation

struct CategoryCellViewModel {
    var name: String
    var image:String
}

class HomeViewModel: NSObject {
    private var networkManager: NetworkManagerProtocol
    var reloadCollectionView: (() -> Void)?
    var categories = Categories(categories: [])
    var categoryCellViewModels = [CategoryCellViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }
    
    
    init(networkManager: NetworkManagerProtocol = NetworkManger.shared) {
        self.networkManager = networkManager
    }
    
    func getCategories() {
        
        networkManager.getCategories() { success, model, error in
            
            if success, let categories = model {
                self.fetchCategoriesData(categories: categories)
            }
            else {
                print(error!)
            }
        }
    }
    
    
    
    func fetchCategoriesData(categories: Categories) {
        self.categories = categories // Cache
        
        var vms = [CategoryCellViewModel]()
        
        for category in categories.categories {
            
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
