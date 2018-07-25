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
                    if (data["success"].int == 1) {
                        let user_id = Int(data["user_id"].string!)!
                        let user_name = data["user_name"].string
                        let user_phone = Int(data["user_phone"].string!)
                        let user_email = data["user_email"].string
                        let user_photo = data["user_photo"].string
                        let user_type = data["user_type"].string
                        let param = [
                            "user_token_id":messageconfig.getDevicetoken(),
                            ]
                        Alamofire.request(Config.UpdateTokenId+data["user_id"].string!, method: .post, parameters:
                            param, encoding: URLEncoding.default, headers: nil)

                        Helper.setUserData(user_id: user_id, user_email: user_email!, user_name: user_name!, user_phone: user_phone!,user_photo: user_photo!,user_type:user_type!)

                        completion(nil ,true)
                    }
                    
                }
                
        }
        
    }
  
    
    class func logOut(completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.Logout+"\(Helper.getuserid())"
        Alamofire.request(BaseUrl)
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
                        Helper.logout()
                        completion(nil ,true)
                    }
                    
                }
                
        }
        
    }
    
    
    
    class func ReseetPassword(username:String ,email:String ,completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.ResetePassword
        let parameters = [
            "user_name":username,
            "user_email": email
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
                        completion(nil ,true)
                    }
                    
                }
                
        }
        
    }
}
