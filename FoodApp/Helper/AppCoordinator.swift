import UIKit

final class AppCoordinator {
    
    private let window:UIWindow
    
    init(window:UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootTabBarController = RootTabBarController()
        window.rootViewController = rootTabBarController
        window.makeKeyAndVisible()
    }
    
}
