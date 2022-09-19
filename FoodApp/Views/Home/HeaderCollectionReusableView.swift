import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let identefier = "header"
    let headerLabel = UILabel()
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textColor = .black
        headerLabel.font = .boldSystemFont(ofSize: 23)
        self.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configurateHeader(title:String) {
        self.headerLabel.text = title
    }
    
}
