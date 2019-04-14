
import Foundation
import UIKit

extension UINavigationController {
    
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            completion?()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }
    
    public func popToViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        popToViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            completion?()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }
}
