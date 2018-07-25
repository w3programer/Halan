import UIKit
import SwiftyJSON
class ordersModel: NSObject {
    var order_id :String = ""
    var order_details :String = ""
    var cost :String = ""
    var order_distance :String = ""
    var order_start_time :String = ""
    var order_date :String = ""
    var order_start_from_minute :String = ""
    var driver_name :String = ""
    var driver_phone :String = ""
    var driver_email :String = ""
    var driver_photo :String = ""
    var driver_id :String = ""
    var driver_national_num:String = ""
    var driver_car_num:String = ""
    var driver_car_model:String = ""
    var driver_car_color:String = ""
    var driver_car_license:String = ""
    var driver_car_form:String = ""
    var driver_car_photo:String = ""
    var market_location :String = ""
    var market_google_lang : Double
    var market_google_lat :Double
    var client_id_fk :String = ""
    var client_name :String = ""
    var client_phone :String = ""
    var client_photo :String = ""
    var client_email :String = ""
    var client_google_lang :Double
    var client_google_lat :Double
    var client_location :String = ""
    init?(dic:[String:JSON]) {
        guard let order_id = dic["order_id"]?.string ,let clientname = dic["client_name"]?.string ,let phone = dic["client_phone"]?.string  else {
            return nil
        }
        self.driver_name = (dic["driver_name"]?.string)!
        self.driver_phone = (dic["driver_phone"]?.string)!
        self.driver_email = (dic["driver_email"]?.string)!
        self.driver_photo = (dic["driver_photo"]?.toImagePath)!
        self.driver_id = (dic["driver_id"]?.string)!
        self.driver_national_num = (dic["driver_national_num"]?.string)!
        self.driver_car_num = (dic["driver_car_num"]?.string)!
        self.driver_car_model = (dic["driver_car_model"]?.string)!
        self.driver_car_color = (dic["driver_car_color"]?.string)!
        self.driver_car_license  = (dic["driver_car_license"]?.string)!
        self.driver_car_form = (dic["driver_car_form"]?.string)!
        self.driver_car_photo = (dic["driver_car_photo"]?.toImagePath)!
        self.client_id_fk = (dic["client_id_fk"]?.string)!
        self.client_name = clientname
        self.client_phone = phone
        self.client_email = (dic["client_email"]?.string)!
        self.client_photo = (dic["client_photo"]?.toImagePath)!

        self.client_location = (dic["client_location"]?.string)!
        self.client_google_lang = (dic["client_google_lang"]?.double)!
        self.client_google_lat = (dic["client_google_lat"]?.double)!
        self.market_location = (dic["market_location"]?.string)!
        self.market_google_lang = (dic["market_google_lang"]?.double)!
        self.market_google_lat = (dic["market_google_lat"]?.double)!
        self.order_id = order_id
        self.order_distance  = (dic["order_distance"]?.string)!
        self.order_details = (dic["order_details"]?.string)!
        self.order_date = (dic["order_date"]?.string)!
        self.order_start_time = (dic["order_start_time"]?.string)!
        self.order_start_from_minute = (dic["order_start_from_minute"]?.string)!
        self.cost = (dic["cost"]?.string)!

        
    }

}
