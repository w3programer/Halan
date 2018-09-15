

import UIKit
import Alamofire
import  SwiftyJSON
extension Api {
    class func driverPay(
        amount:String ,date:String ,bank:String,code:String,completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.pay
        let parameters = [
            "amount":amount,
            "date": date,
            "bank":bank,
            "code":code,
            "user_id":"\(Helper.getuserid())"

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
                    if  (data["success"].int == 1) {
                        completion(nil ,true)
                    }
                }
                
        }
        
    }
}

