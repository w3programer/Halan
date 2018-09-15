import UIKit
import SwiftyJSON
class driverModel: NSObject {
    var driver_id :String = ""
    var user_google_lat :Double
    var user_google_long :Double 
    var user_name :String = ""
    var user_phone :String = ""
    var user_photo :String = ""
    init?(dic:[String:JSON]) {
        guard let id = dic["driver_id"]?.string ,let late = dic["user_google_lat"]?.string ,let long = dic["user_google_long"]?.string  else {
            return nil
        }
        self.driver_id = id
        self.user_google_lat = Double(late)!
        self.user_google_long = Double(long)!
        self.user_name = (dic["user_name"]?.string)!
        self.user_phone = (dic["user_phone"]?.string)!
        self.user_photo = (dic["user_photo"]?.toImagePath)!
    }

    
}
