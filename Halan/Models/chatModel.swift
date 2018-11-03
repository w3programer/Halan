import UIKit
import SwiftyJSON
class chatModel: NSObject {
    var id_message :String = ""
    var room_id_fk :String = ""
    var message_type :String = ""
    var image :String = ""
    var message :String = ""
    var from_name :String = ""
    var from_id :String = ""
    var from_type :String = ""
    var from_photo :String = ""
    var to_name :String = ""
    var to_id :String = ""
    var to_type :String = ""
    var to_photo :String = ""
    var message_date :String = ""
    var message_time :String = ""
    init?(dic:[String:JSON]) {
        guard let message = dic["message"]?.string ,let imagebill = dic["image"]?.toImagePath  else {
            return nil
        }
        self.message = message
        self.room_id_fk  = (dic["room_id_fk"]?.string)!
        self.message_type   = (dic["message_type"]?.string)!
        self.from_name   = (dic["from_name"]?.string)!
        self.from_id   = (dic["from_id"]?.string)!
        self.from_type   = (dic["from_type"]?.string)!
        self.from_photo   = (dic["from_photo"]?.toImagePath)!
        self.to_name  = (dic["to_name"]?.string)!
        self.to_id   = (dic["to_id"]?.string)!
        self.to_type  = (dic["to_type"]?.string)!
        self.to_photo  = (dic["to_photo"]?.toImagePath)!
        self.message_date  = (dic["message_date"]?.string)!
        self.message_time  = (dic["message_time"]?.string)!
        self.image = imagebill

    }
    
    
}
