import Foundation
import UIKit

struct CategoryCellViewModel {
    var name: String
    var image:String
}

final class HomeViewModel: NSObject {
    var reloadCollectionView: (() -> Void)?
    var categories = [Category]()
    var categoryCellViewModels = [CategoryCellViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }
    
    
    //MARK: - Category collection UI setup
    public func numberOfSections() -> Int {
        1
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
    
    
    
    private func fetchCategoriesData(categories: [Category]) {
        self.categories = categories // Cache
        
        var vms = [CategoryCellViewModel]()
        
        for category in categories {
            vms.append(createCategoryCellModel(category: category))
        }
        categoryCellViewModels = vms
    }
    
    private func createCategoryCellModel(category: Category) -> CategoryCellViewModel {
        let name = category.strCategory
        let image = category.image
        return CategoryCellViewModel(name: name, image: image)
    }
    
    private func getCategoryCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel {
        return categoryCellViewModels[indexPath.row]
    }
    
    
}
