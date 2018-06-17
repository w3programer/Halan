import UIKit
import Alamofire
import  SwiftyJSON
extension Api {
    class func login(username:String ,password:String ,completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.login
        let parameters = [
            "user_name":username,
            "user_pass": password
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
                    if  (data["success"].string != "0") {
                        ///////
                        let user_id = Int(data["user_id"].string!)!
                        let user_name = data["user_name"].string
                        let user_phone = Int(data["user_phone"].string!)
                        let user_email = data["user_email"].string
                        /////////
                        Helper.setUserData(user_id: user_id, user_email: user_email!, user_name: user_name!, user_phone: user_phone!)
                        completion(nil ,true)
                    }
                    
                }
                
        }
        
    }
}
