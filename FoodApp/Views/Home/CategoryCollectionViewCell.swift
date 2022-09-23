import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    static let identefier = "categoryCell"
    
    let nameLabel = UILabel()
    let foodImageView = UIImageView()
    override var isSelected: Bool{
        didSet {
            self.backgroundColor = isSelected ? UIColor(named: Constant.orangeColorName) : .white
        }
    }
    var cellViewModel:CellViewModel?{
        didSet{
            nameLabel.text = cellViewModel?.name
            guard let urlString = cellViewModel?.image else {return}
            self.fetchImage(urlString: urlString)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 40
        
        let circleView:UIView = {
           let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.masksToBounds = true
            view.layer.cornerRadius = view.frame.width / 2
            return view
        }()
        self.addSubview(circleView)
        
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        foodImageView.contentMode = .scaleAspectFill
        circleView.addSubview(foodImageView)
        
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 11)
        self.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 60),
            circleView.heightAnchor.constraint(equalToConstant: 60),
            foodImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            foodImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            foodImageView.widthAnchor.constraint(equalToConstant: circleView.frame.width - 10),
            foodImageView.heightAnchor.constraint(equalToConstant: circleView.frame.height - 10),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor,constant: 10)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func fetchImage(urlString:String) {
        guard let url = URL(string: urlString) else {
            self.foodImageView.image = UIImage(systemName: Constant.failedImageName)
            return
        }
        
        if let image = ImageCache.shared[url] {
            DispatchQueue.main.async {
                self.foodImageView.image = image
            }
            return
        }
        
        let imageRequest = ImageRequest(url: url)
        
        DispatchQueue.global(qos: .userInitiated).async {
            imageRequest.execute(withCompletion: {[weak self] image, error in
                DispatchQueue.main.async {
                    ImageCache.shared[url] = image
                    self?.foodImageView.image = image
                }
            })
        }
        
    }
    
}
