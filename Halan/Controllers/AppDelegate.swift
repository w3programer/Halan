import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import IQKeyboardManagerSwift
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate{
    var window: UIWindow?
    var tokenid  = ""
    let locationmanager = CLLocationManager()
    var location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
             self.updateLocation()
        GMSServices.provideAPIKey("AIzaSyArjmbYWTWZhDFFtPOLRLKYwjtBDkOEGrY")
        GMSPlacesClient.provideAPIKey("AIzaSyBNUlPmpibuzvp2C3bMn9z2c_kXzmFjD7Q")
        
        
         if Helper.getUserData() == true {
        let tab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
         window?.rootViewController = tab
        
         }
        FirebaseApp.configure()
        
        
        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { granted, error in }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshtoken(notifaction:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
       
//        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
//            // 2
//            let aps = notification["aps"] as! [String: AnyObject]
//           // _ = NewsItem.makeNewsItem(aps)
//            // 3
//            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
 //       }

        
        IQKeyboardManager.shared.enable = true
        return true
    }
   
    func applicationWillResignActive(_ application: UIApplication) {
        updateLocation()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.updateLocation()
     Messaging.messaging().shouldEstablishDirectChannel = true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.updateLocation()
    
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

         firebasehandler()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


   //////notifactions
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
//            let viewAction = UNNotificationAction(identifier: "NOTIFACTION",
//                                                  title: "View",
//                                                  options: [.foreground])
//
//            // 2
//            let newsCategory = UNNotificationCategory(identifier: "notifaction",
//                                                      actions: [viewAction],
//                                                      intentIdentifiers: [],
//                                                      options: [])
//            // 3
//            UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
//
            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    ////////////////////////////////////////////////////////////////
    
    func updateLocation(){
        self.self.locationmanager.requestAlwaysAuthorization()
        self.locationmanager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationmanager.delegate = self
            self.locationmanager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationmanager.distanceFilter = 10
            self.locationmanager.startMonitoringSignificantLocationChanges()
            self.locationmanager.startUpdatingLocation()
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
extension AppDelegate:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = manager.location!.coordinate
    
        if  Helper.isDriver() == true{
            Api.updateDriveLocation(late: self.location.latitude, long: self.location.longitude) { (error:Error?, success:Bool) in
                if success == true{
                   print("location updated success")
                }
            }
        }
        
        
        
 
    }

    
    
}







