
import UIKit
import Alamofire
import  SwiftyJSON
class Api: NSObject {    
    class func registration(
        username:String ,password:String ,email:String,phone:String,fullname:String,age:String,gender:String,photo:String,token:String,completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.registration
        let parameters = [
            "user_name":username,
            "user_pass": password,
            "user_email":email,
            "user_phone": phone,
            "user_full_name":fullname,
            "user_age":age,
            "user_gender":gender,
            "user_photo":photo,
            "user_token_id":token
            ]
        Alamofire.request(BaseUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode:200..<300)
            .responseJSON { response in
                switch response.result
                {
                case .failure( let error):
                    print(error)
                    completion(error , false)
                case .success(let value):
                    let data = JSON(value)
                    //print(data)
                    if  (data["success"].int == 1) {
                        
                        ///////
                        let user_id = Int(data["user_id"].string!)!
                        let user_name = data["user_name"].string
                        let user_phone = Int(data["user_phone"].string!)
                        let user_email = data["user_email"].string
                        let user_photo = data["user_photo"].string

                        /////////
                        Helper.setUserData(user_id: user_id, user_email: user_email!, user_name: user_name!, user_phone: user_phone!,user_photo: user_photo!)
                        completion(nil ,true)
                    }
                }
                
        }
        
    }
    //////////////all offers
    
    
}

