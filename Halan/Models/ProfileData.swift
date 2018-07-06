
import UIKit
import SwiftyJSON
class ProfileData: NSObject {

    
    var user_name :String = ""
    var user_full_name :String = ""
    var user_phone :String = ""
    var user_email :String = ""
    var user_photo :String = ""
    init?(dic:[String:JSON]) {
        guard let image = dic["user_photo"]?.toImagePath , let user_name = dic["user_name"]?.string  else {
            return nil
        }
        self.user_name = user_name
        self.user_photo = image
        self.user_email = (dic["user_email"]?.string)!
        self.user_full_name = (dic["user_full_name"]?.string)!
        self.user_phone = (dic["user_phone"]?.string)!

    }

    

    
    
    
    
    
    
}
