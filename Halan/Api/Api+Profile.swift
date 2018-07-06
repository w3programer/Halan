
import Foundation
import Alamofire
import SwiftyJSON
extension Api{
    class func profile(completion:@escaping (_ error:Error?, _ data:[ProfileData]?)->Void){
        Alamofire.request(Config.profile+String(Helper.getuserid())).responseJSON{response in
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
                print(error)
            case.success(let value):
                let json = JSON(value)
                // print(json)
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var results = [ProfileData]()
                for data in dataArr {
                    
                    if let data = data.dictionary ,let info = ProfileData.init(dic: data) {
                        results.append(info)
                    }
                }
                completion(nil,results)
            }
            
        }
    }

    class func updateprofile (name:String ,username:String ,phone:String,email:String,photo:String,completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.UpdateClient+String(Helper.getuserid())
        let parameters = [
            "user_full_name":name,
            "user_name":username,
            "user_email": email,
            "user_phone": phone,
            "user_photo":photo
            ]
        Alamofire.request(BaseUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode:200..<300)
            .responseJSON { response in
                switch response.result
                {
                case .failure( let error):
                    completion(error , false)
                case .success(let value):
                    let data = JSON(value)
                    if  (data["success"].string != "0") {
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
    
    
    
    
    
    
    
}

