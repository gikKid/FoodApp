import Foundation
import UIKit

final class HomeViewController:UIViewController {
    
    lazy var viewModel = {
       HomeViewModel()
    }()
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.initViewModel()
    }
    
    //MARK: - Setup view
    private func setupView() {
        self.view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.isHidden = true
        
        let menuButton:UIButton =  {
           let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(systemName: "text.alignright"), for: .normal)
            button.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            button.tintColor = .black
            button.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
        self.view.addSubview(menuButton)
        
        let searchButton:UIButton = {
           let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            button.tintColor = .black
            button.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            button.backgroundColor = .white
            button.clipsToBounds = true
            button.layer.cornerRadius = 12
            return button
        }()
        self.view.addSubview(searchButton)
        
        let bellButton:UIButton = {
           let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(systemName: "bell"), for: .normal)
            button.tintColor = .black
            button.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            button.backgroundColor = .white
            button.clipsToBounds = true
            button.layer.cornerRadius = 12
            return button
        }()
        self.view.addSubview(bellButton)
        
        let topLabel:UILabel = {
           let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Discover your favourite food."
            label.numberOfLines = 2
            label.font = .boldSystemFont(ofSize: 30)
            label.textColor = .black
            return label
        }()
        self.view.addSubview(topLabel)
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout.init()
        collectionViewFlowLayout.scrollDirection = .horizontal
        self.collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: false)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.backgroundColor = .clear
        self.collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identefier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.view.addSubview(collectionView)
    
        
        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: searchButton.topAnchor),
            menuButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            menuButton.widthAnchor.constraint(equalTo: searchButton.widthAnchor),
            menuButton.heightAnchor.constraint(equalTo: searchButton.heightAnchor),
            searchButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10),
            searchButton.rightAnchor.constraint(equalTo: bellButton.leftAnchor, constant: -15),
            searchButton.widthAnchor.constraint(equalToConstant: searchButton.frame.width + 43),
            searchButton.heightAnchor.constraint(equalToConstant: searchButton.frame.height + 43),
            bellButton.topAnchor.constraint(equalTo: searchButton.topAnchor),
            bellButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            bellButton.widthAnchor.constraint(equalTo: searchButton.widthAnchor, constant: 0),
            bellButton.heightAnchor.constraint(equalTo: searchButton.heightAnchor, constant: 0),
            topLabel.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 40),
            topLabel.leftAnchor.constraint(equalTo: menuButton.leftAnchor),
            topLabel.widthAnchor.constraint(equalToConstant: 250),
            collectionView.topAnchor.constraint(equalTo: topLabel.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func initViewModel() {
        self.viewModel.getCategories()
        self.viewModel.reloadCollectionView = {[weak self]  in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    
    //MARK: - Buttons methods
    @objc private func menuButtonTapped(_ sender:UIButton) {
        
    }

    
}

//MARK: - Collection view methods
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         self.viewModel.categoryCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identefier, for: indexPath) as? CategoryCollectionViewCell else {
            fatalError()
        }
        let cellViewModel = self.viewModel.getCategoryCellViewModel(at: indexPath)
        cell.cellViewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: 50)
    }
    
    
}
