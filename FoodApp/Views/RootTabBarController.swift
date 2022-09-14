import Foundation

import UIKit

final class RootTabBarController: UITabBarController {
    
    private struct Constant {
        static let homeImageName = "homeGray"
        static let homeImageSelectedName = "homeOrange"
        static let favoriteImageName = "heartGray"
        static let favoriteImageSelectedName = "heartOrange"
        static let mapImageName = "compasGray"
        static let mapImageSelectedName = "compasOrange"
        static let cartImageName = "cartGray"
        static let cartImageSelectedName = "cartOrange"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()

    }
    
    
    //MARK: - Setup view
    private func setupView() {
        self.tabBar.backgroundColor = .white
        
        var tabBarViewControllers = [UIViewController]()
        
        let homeVC = HomeViewController()

        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.tintColor = .orange
        
        let homeTabBarItem = UITabBarItem(title: nil, image: UIImage(named: RootTabBarController.Constant.homeImageName), selectedImage:UIImage(named: RootTabBarController.Constant.homeImageSelectedName))
        homeVC.tabBarItem = homeTabBarItem
        
        let homeVCNavigationController = UINavigationController()
        homeVCNavigationController.viewControllers = [homeVC]
        tabBarViewControllers.append(homeVCNavigationController)
        
        let favoriteVC = FavoriteViewController()
        let favoriteTabBarItem = UITabBarItem(title: nil, image: UIImage(named: RootTabBarController.Constant.favoriteImageName), selectedImage: UIImage(named: RootTabBarController.Constant.favoriteImageSelectedName))
        favoriteVC.tabBarItem = favoriteTabBarItem
        tabBarViewControllers.append(favoriteVC)
        
        let mapVC = MapViewController()
        let mapTabBarItem = UITabBarItem(title: nil, image: UIImage(named: RootTabBarController.Constant.mapImageName), selectedImage: UIImage(named: RootTabBarController.Constant.mapImageSelectedName))
        mapVC.tabBarItem = mapTabBarItem
        tabBarViewControllers.append(mapVC)
        
        let cartVC = CartViewController()
        let cartTabBarItem = UITabBarItem(title: nil, image: UIImage(named: RootTabBarController.Constant.cartImageName), selectedImage: UIImage(named: RootTabBarController.Constant.cartImageSelectedName))
        cartVC.tabBarItem = cartTabBarItem
        tabBarViewControllers.append(cartVC)
        
        self.viewControllers = tabBarViewControllers
        self.selectedIndex = 0
        
    }



}
