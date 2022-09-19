import Foundation
import UIKit

final class HomeViewController:UIViewController {
    
    lazy var viewModel = {
       HomeViewModel()
    }()
    private var categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var mealCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let categoryHeaderId = "categoryHeaderId"
    
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
        
        let categoryCollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        categoryCollectionViewFlowLayout.scrollDirection = .horizontal
        categoryCollectionViewFlowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        self.categoryCollectionView.setCollectionViewLayout(categoryCollectionViewFlowLayout, animated: false)
        self.categoryCollectionView.showsHorizontalScrollIndicator = false
        self.categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.categoryCollectionView.backgroundColor = .clear
        self.categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identefier)
        self.categoryCollectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HeaderCollectionReusableView.identefier)
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        //self.view.addSubview(categoryCollectionView)
        
        let mealCollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        mealCollectionViewFlowLayout.scrollDirection = .horizontal
        mealCollectionViewFlowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        self.mealCollectionView.setCollectionViewLayout(mealCollectionViewFlowLayout, animated: false)
        self.mealCollectionView.showsHorizontalScrollIndicator = false
        self.mealCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.mealCollectionView.backgroundColor = .clear
        self.mealCollectionView.register(RecommendedMealCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedMealCollectionViewCell.identefier)
        self.mealCollectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HeaderCollectionReusableView.identefier)
        self.mealCollectionView.dataSource = self
        self.mealCollectionView.delegate = self
        //self.view.addSubview(mealCollectionView)
    
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(RecommendedMealCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedMealCollectionViewCell.identefier)
        self.collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identefier)
        self.collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: self.categoryHeaderId, withReuseIdentifier: HeaderCollectionReusableView.identefier)
        self.collectionView.collectionViewLayout = createCompositionalLayout()
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
//            categoryCollectionView.topAnchor.constraint(equalTo: topLabel.bottomAnchor),
//            categoryCollectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
//            categoryCollectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
//            categoryCollectionView.heightAnchor.constraint(equalToConstant: 200),
//            mealCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor),
//            mealCollectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
//            mealCollectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
//            mealCollectionView.bottomAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.bottomAnchor)
            collectionView.topAnchor.constraint(equalTo: topLabel.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor)
        ])
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return self.firstLayoutSection()
            default:
                return self.secondLayoutSection()
            }
        }
    }
    
    private func firstLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.85))
         
         let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 0)
         
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalWidth(0.35))
         
         let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
         let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 15, bottom: 20, trailing: 0)
         section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), elementKind: categoryHeaderId, alignment: .topLeading)]
         return section
    }
    
    private func secondLayoutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
         
         let item = NSCollectionLayoutItem(layoutSize: itemSize)
         //item.contentInsets.bottom = 15
         
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalWidth(1))
         
         let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
         group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 2)
        
         let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), elementKind: categoryHeaderId, alignment: .topLeading)]
         
         section.orthogonalScrollingBehavior = .continuous
         
         return section
    }
    
    
    private func initViewModel() {
        self.viewModel.getCategories()
        self.viewModel.reloadCetegoryCollectionView = {[weak self]  in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
//                self?.categoryCollectionView.reloadData()
//                self?.categoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }
            
        }
        self.viewModel.reloadMealsCollectionView = {[weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadSections(IndexSet(integer:1))
                //self?.mealCollectionView.reloadData()
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
        2
        //return self.viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return self.viewModel.categoryCellViewModels.count
        default:
            return self.viewModel.recommendedMealCellViewModels.count
        }
        
//        switch collectionView {
//        case categoryCollectionView:
//            return self.viewModel.categoryCellViewModels.count
//        case mealCollectionView:
//            return self.viewModel.recommendedMealCellViewModels.count
//        default:
//            return 0
//        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
             return self.viewModel.setupCategoryCell(collectionView: collectionView, cellForItemAt: indexPath)
        default:
            return self.viewModel.setupMealCell(collectionView: collectionView, cellForItemAt: indexPath)
        }
        
//        switch collectionView {
//        case categoryCollectionView:
//            return self.viewModel.setupCategoryCell(collectionView: collectionView, cellForItemAt: indexPath)
//        case mealCollectionView:
//            return self.viewModel.setupMealCell(collectionView: collectionView, cellForItemAt: indexPath)
//        default:
//            return UICollectionViewCell()
//        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        switch collectionView {
////        case categoryCollectionView:
////            return self.viewModel.setupCategoryCellSize()
////        case mealCollectionView:
////            return self.viewModel.setupMealCellSize()
////        default:
////            return CGSize()
////        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            self.viewModel.didSelectCategoryItemAt(collectionView: collectionView, didSelectItemAt: indexPath)
        default:
            break
        }
        
//        switch collectionView {
//        case categoryCollectionView:
//            self.viewModel.didSelectCategoryItemAt(collectionView: collectionView, didSelectItemAt: indexPath)
//        case mealCollectionView:
//            self.viewModel.didSelectMealItemAt(collectionView: collectionView, didSelectItemAt: indexPath)
//        default:
//            break
//        }
  }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch indexPath.section {
        case 0:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identefier, for: indexPath) as? HeaderCollectionReusableView else {return UICollectionReusableView()}
            header.configurateHeader(title: "Categories")
            return header
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identefier, for: indexPath) as? HeaderCollectionReusableView else {return UICollectionReusableView()}
            header.configurateHeader(title: "Most Recommended")
            return header
        }
        
        
        
//            switch collectionView {
//            case categoryCollectionView:
//                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identefier, for: indexPath) as? HeaderCollectionReusableView else {return UICollectionReusableView()}
//                header.configurateHeader(title: "Categoroies")
//                return header
//            case mealCollectionView:
//                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identefier, for: indexPath) as? HeaderCollectionReusableView else {return UICollectionReusableView()}
//                header.configurateHeader(title: "Most Recommended")
//                return header
//            default:
//                return UICollectionReusableView()
//            }
    }
    
    
    
}

