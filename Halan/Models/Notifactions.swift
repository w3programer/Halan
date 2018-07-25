import UIKit
import SwiftyJSON
class Notifactions: NSObject {
    var order_id :String = ""
    var order_details :String = ""
    var order_driver_cost :String = ""
    var message_id :String = ""
    var messages_status :String = ""
    var order_date :String = ""
    var market_location :String = ""
    var market_google_lang : Double
    var market_google_lat :Double
    var client_id_fk :String = ""
    var client_name :String = ""
    var client_phone :String = ""
    var client_google_lang :Double
    var client_google_lat :Double
    var client_location :String = ""
    init?(dic:[String:JSON]) {
        guard let message = dic["message_id"]?.string ,let clientname = dic["client_name"]?.string ,let phone = dic["client_phone"]?.string  else {
            return nil
        }
        self.message_id = message
        self.order_id = (dic["order_id"]?.string)!
        self.client_id_fk = (dic["client_id_fk"]?.string)!
        self.client_name = clientname
        self.client_phone = phone

        self.messages_status = (dic["messages_status"]?.string)!
        self.client_location = (dic["client_location"]?.string)!
        self.client_google_lang = (dic["client_google_lang"]?.double)!
        self.client_google_lat = (dic["client_google_lat"]?.double)!
        self.market_location = (dic["market_location"]?.string)!
        self.market_google_lang = (dic["market_google_lang"]?.double)!
        self.market_google_lat = (dic["market_google_lat"]?.double)!
        self.order_driver_cost = (dic["order_driver_cost"]?.string)!
        self.order_details = (dic["order_details"]?.string)!
        self.order_date = (dic["order_date"]?.string)!

}

}
