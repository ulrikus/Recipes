import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }
        
        let navigationController = UINavigationController(rootViewController: RecipiesTableViewController())
        window.rootViewController = navigationController
        navigationController.navigationBar.isTranslucent = false
        window.makeKeyAndVisible()
        
        return true
    }
}
