//


import UIKit

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var vacations : NSArray?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        loadData()

        let splitViewController = window!.rootViewController as! UISplitViewController
        
        let navigationController = splitViewController.viewControllers.first as!
        UINavigationController
        if let masterViewController = navigationController.topViewController as?
            MasterViewController {
            masterViewController.vacations = vacations

        }
        // detail
        let detailNavController = splitViewController.viewControllers.last as!UINavigationController
        
        detailNavController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        
        splitViewController.delegate = self
        
        
        return true
    }
    
    func loadData() {
        self.vacations = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/col.plist")
        
        if self.vacations?.count ?? 0 <= 0 {
            let model = VacationCodable.init(title:"Sky observation deck", latitude: "20.99" ,Longitude: "30.99", cost: "23", date: "October 1st", remark: "Sky glass slide", imgdata:"")
            
            do{
                let data = try JSONEncoder().encode(model)
                let json = String(data: data, encoding: .utf8)
                
                let array = NSArray(objects: json ?? "")
                let filePath:String = NSHomeDirectory() + "/Documents/col.plist"
                array.write(toFile: filePath, atomically: true)
                
            }catch {
                
            }
        }
        
    }
//
//    func saveDate() {
//        let array = NSArray(objects: "apple","orange","pear","banana","watermelon")
//        let filePath:String = NSHomeDirectory() + "/Documents/fruit.plist"
//        array.write(toFile: filePath, atomically: true)
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

