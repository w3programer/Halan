import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var tokenid  = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
     

        GMSServices.provideAPIKey("AIzaSyAX9Mtf7HEkQxVcofftrYiVVD0hqbeNx6o")
        GMSPlacesClient.provideAPIKey("AIzaSyAX9Mtf7HEkQxVcofftrYiVVD0hqbeNx6o")
        
        
         if Helper.getUserData() == true {
        let tab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
         window?.rootViewController = tab
        
         }
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge , .sound]) { (success, error) in
            if error == nil {
              print("success")
            }else{
              print("failed to run notifaction ")
            }
            
        }
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshtoken(notifaction:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        
        IQKeyboardManager.shared.enable = true
        return true
    }
 
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

     Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

         firebasehandler()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let refreshedToken = InstanceID.instanceID().token() {
          print("InstanceID token: \(refreshedToken)")
            
        }
    }

}
extension AppDelegate{
    @objc func refreshtoken(notifaction:NSNotification)  {
      let token  = InstanceID.instanceID().token()!
        print("the token is hesham \(token)")
        firebasehandler()
    }
    func firebasehandler(){
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
 
}
