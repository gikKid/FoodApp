import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identefier = "categoryCell"
    
    let nameLabel = UILabel()
    
    var cellViewModel:CategoryCellViewModel?{
        didSet{
            nameLabel.text = cellViewModel?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
