
import Foundation
import Alamofire
import SwiftyJSON
extension Api{
    class func NotifactionsApi(completion:@escaping (_ error:Error?, _ data:[Notifactions]?)->Void){
        
        var urlstr = ""
        if Helper.isDriver() == true{
            urlstr = Config.driverRequests
        }else{
            urlstr = Config.ClientRequests
  
        }
        Alamofire.request(urlstr).responseJSON{response in
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
                var notifaction = [Notifactions]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = Notifactions.init(dic: data) {
                        notifaction.append(result)
                    }
                }
                completion(nil,notifaction)
            }
            
        }
    }
    
//////driver action
    class func driverAction(action:String ,messageid:String,orderid:String,clientid:String ,completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.DriverAction
        let parameters = [
            "action":action,
            "message_id": messageid,
            "order_id_fk":orderid,
            "client_id_fk":clientid
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
                        print(data["message"].string ?? "hhhhhhhhh")
                    }
                    
                }
                
        }
        
    }
    
}
