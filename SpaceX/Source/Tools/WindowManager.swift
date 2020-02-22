
import Foundation
import UIKit

class WindowManager {
    
    enum Tab: Equatable {
        case launches
        case rockets
        
        var title: String? {
            switch self {
            case .launches: return "Launches"
            case .rockets: return "Rockets"
            }
        }
        
        var itemImage: UIImage? {
            return nil
        }
        
        func viewController() -> UIViewController {
            switch self {
            case .launches: return LaunchesViewController(viewModel: LaunchesViewModel(api: SpaceXAPI))
            case .rockets:  return RocketsViewController(viewModel: RocketsViewModel(api: SpaceXAPI))
            }
        }
    }
    
    static let shared = WindowManager()
    let rootNavigationController = UINavigationController()
    var tabBarController: UITabBarController?
    private(set) var tabs = [Tab]()
    
    var isTabBarControllerVisible: Bool {
        return WindowManager.shared.tabBarController?.view.window != nil
    }
    
    func initializeWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        rootNavigationController.isNavigationBarHidden = true
        rootNavigationController.pushViewController(UIViewController(), animated: false)
        window.rootViewController = rootNavigationController
        
        window.makeKeyAndVisible()
        
        return window
    }
    
    func nukeMainUserInterface() {
        tabBarController?.removeFromParent()
        tabBarController = nil
        rootNavigationController.popToRootViewController(animated: false)
    }
    
    func showMainUserInterface() {
        tabBarController = UITabBarController()
        guard let tabBarController = tabBarController else { return }
//        tabBarController.delegate = self
        
        self.tabs = [.launches, .rockets]
        
        tabBarController.viewControllers = tabs.enumerated().map { (idx, tab) -> UIViewController in
            let viewController = tab.viewController()
            let tabBarItem = UITabBarItem(title: tab.title, image: tab.itemImage?.withRenderingMode(.alwaysOriginal), tag: idx)
//            tabBarItem.imageInsets = showTextLabels ? .zero : UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//            tabBarItem.selectedImage = tab.itemImage
            viewController.tabBarItem = tabBarItem
//            viewController.navigationItem.backBarButtonItem = UIBarButtonItem.backButton()
            return UINavigationController(rootViewController: viewController)
        }
        
        tabBarController.tabBar.isHidden = true
        
        rootNavigationController.pushViewController(tabBarController, animated: false)
    }
    
    func rootViewController(for tab: Tab) -> UIViewController? {
        guard let index = tabs.firstIndex(of: tab) else { return nil }
        guard let navigationController = tabBarController?.viewControllers?.at(index) as? UINavigationController else { return nil }
        return navigationController.viewControllers.first
    }
    
    static var rootWindow: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static var isRootWindowKeyWindow: Bool {
        return UIApplication.shared.keyWindow == rootWindow
    }
    
    static func topMostViewController() -> UIViewController? {
        guard let rootViewController = rootWindow?.rootViewController else { return nil }
        
        let visibleViewController = recusivelyVisibleViewControllerOnViewController(rootViewController)
        if !visibleViewController.isEqual(rootViewController) {
            return visibleViewController
        }
        return rootViewController
    }
    
    static func recusivelyVisibleViewControllerOnViewController(_ viewController: UIViewController) -> UIViewController {
        
        if let navCon = viewController as? UINavigationController, let visible = navCon.visibleViewController {
            return visible
        } else if let presented = viewController.presentedViewController {
            return self.recusivelyVisibleViewControllerOnViewController(presented)
        } else {
            return viewController
        }
    }
    
    static func topMostNavigationController() -> UINavigationController? {
        let topMostController = topMostViewController()
        
        if topMostController is UITabBarController {
            return WindowManager.shared.tabBarController?.selectedViewController as? UINavigationController
        } else {
            return topMostController?.navigationController
        }
    }
    
    static var visibleViewController: UIViewController? {
        return getVisibleViewControllerFrom(rootWindow?.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}
