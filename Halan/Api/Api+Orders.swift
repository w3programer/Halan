import UIKit
import Alamofire
import  SwiftyJSON
extension Api{
    class func ordersApi(url:String,completion:@escaping (_ error:Error?, _ data:[ordersModel]?)->Void){
        Alamofire.request(url).responseJSON{response in
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
                //print(error)
            case.success(let value):
                let json = JSON(value)
                print(json)
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var orders = [ordersModel]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = ordersModel.init(dic: data) {
                        orders.append(result)
                    }
                }
                completion(nil,orders)
            }
            
        }
    }
    
    //////order action
    class func driverCancel(orderid:String,clientid:String ,completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.driverCancelOrder
        let parameters = [
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
                    }
                    
                }
                
        }
        
    }
    //client cancel
    class func clientCancelorder(orderid:String ,driverid:String,reason:String,completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.clientCancerOrder
        let parameters = [
            "order_id_fk":orderid,
            "driver_id_fk":driverid,
            "cancel_reason_type":reason
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
/////delivared
    class func orderDelivered(orderid:String,completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.orderDelivered + orderid
        let parameters = [
            "user_type":Helper.getUserType()
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
 /////////////////request order to drivers
    class func requestOrderTodriver(clientlocation:String,clientLat:Double,clientLong:Double,marketlocation:String,marketlat:Double,marketlong:Double,distance:String,orderdetailes:String,cost:String,drivers:Array<String>,completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.AddMyOrder
        let parameters = [
            "user_id":Helper.getuserid(),
            "client_location":clientlocation,
            "client_google_lang":clientLong,
            "client_google_lat":clientLat,
            "market_location":marketlocation,
            "market_google_lang":marketlong,
            "market_google_lat":marketlat,
            "distance":distance,
            "order_details":orderdetailes,
            "total_cost":cost,
            "driver_id":drivers
            ] as [String : Any]
        //print(parameters)
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
                    print(data)
                    if  (data["success"].int == 1) {
                        completion(nil ,true)
                    }
                    
                }
                
        }
        
    }
}
