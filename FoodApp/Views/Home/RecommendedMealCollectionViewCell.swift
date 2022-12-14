import UIKit

class RecommendedMealCollectionViewCell: UICollectionViewCell {
    
    static let identefier = "recommendedMealCell"
    let nameLabel = UILabel()
    let mealImageView = UIImageView()
    var cellViewModel:CellViewModel? {
        didSet {
            nameLabel.text = cellViewModel?.name
            guard let urlString = cellViewModel?.image else {return}
            self.fetchImage(urlString: urlString)
        }
    }
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.numberOfLines = 2
        self.addSubview(nameLabel)
        
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.layer.masksToBounds = true
        mealImageView.layer.cornerRadius = 12
        self.addSubview(mealImageView)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.addSubview(activityIndicator)
        
        let addCartButton = UIButton()
        addCartButton.backgroundColor = UIColor(named: Constant.orangeColorName)
        addCartButton.setImage(UIImage(named: "cartBlack"), for: .normal)
        addCartButton.translatesAutoresizingMaskIntoConstraints = false
        addCartButton.layer.masksToBounds = true
        addCartButton.layer.cornerRadius = 20
        self.addSubview(addCartButton)
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            mealImageView.widthAnchor.constraint(equalToConstant: self.frame.width - 20),
            mealImageView.heightAnchor.constraint(equalTo: mealImageView.widthAnchor),
            mealImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            addCartButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            addCartButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            addCartButton.widthAnchor.constraint(equalToConstant: addCartButton.frame.width + 40),
            addCartButton.heightAnchor.constraint(equalToConstant: addCartButton.frame.width + 40),
            activityIndicator.centerXAnchor.constraint(equalTo: mealImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: mealImageView.centerYAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func fetchImage(urlString:String) {
        guard let url = URL(string: urlString) else {
            self.mealImageView.image = UIImage(systemName: Constant.failedImageName)
            return
        }
        
        if let image = ImageCache.shared[url] {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.mealImageView.image = image
            }
            return
        }
        
        let imageRequest = ImageRequest(url: url)
        
        DispatchQueue.global(qos: .userInitiated).async {
            imageRequest.execute(withCompletion: {[weak self] image, error in
                DispatchQueue.main.async {
                    ImageCache.shared[url] = image
                    self?.activityIndicator.stopAnimating()
                    self?.mealImageView.image = image
                }
            })
        }
    }
}
