
import Foundation
import UIKit

struct Style {
    struct appearance {
        
        static func applyTranslucentNavigationBarAppearance(to navigationBar: UINavigationBar?) {
            navigationBar?.setBackgroundImage(UIImage(), for: .default)
            navigationBar?.backgroundColor = .clear
            navigationBar?.barTintColor = .clear
            navigationBar?.shadowImage = UIImage()
            navigationBar?.isTranslucent = true
        }
        
        static func applyDefaultNavigationBarAppearance(to navigationBar: UINavigationBar?) {
            navigationBar?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            navigationBar?.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            navigationBar?.isTranslucent = false
            navigationBar?.barStyle = .black
        }
        
        static func setUpAppearance() {
            UINavigationBar.appearance().tintColor = UIColor.white
            UINavigationBar.appearance().shadowImage = UIImage()
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
            
            applyDefaultNavigationBarAppearance(to: UINavigationBar.appearance())
            
//            UITabBar.appearance().tintColor = .primaryColor
//            UITabBar.appearance().barTintColor = .darkBlueBackgroundColor
            
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: font.light(size: 10)], for: .normal)
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.primaryColor], for: .selected)
            
//            UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = .light(size: 12)
            
//            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white,
//                                                                                                                   NSAttributedStringKey.font: UIFont.regular(size: 17)], for: .normal)
//            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setBackgroundImage(UIImage.image(with: UIColor.clear), for: .normal, barMetrics: .default)
        }
        
    }
}

extension UIColor {
    static let lightTextColor = #colorLiteral(red: 0, green: 0.4312615395, blue: 0.8313364983, alpha: 1)
    static let failedColor = #colorLiteral(red: 0.8274509804, green: 0.2352941176, blue: 0.2352941176, alpha: 1)
    static let succeededColor = #colorLiteral(red: 0.368627451, green: 0.8274509804, blue: 0.2352941176, alpha: 1)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
