import UIKit
import Alamofire
import  SwiftyJSON
extension Api {
    class func updateDriveLocation(late:Double ,long:Double ,completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.updateDriverLocation
        let parameters = [
            "user_google_lat":late,
            "user_google_long": long,
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
                        
                        completion(nil ,true)
                    }
                    
                }
                
        }


    }
    class func avilableDriver(completion:@escaping (_ error:Error?, _ data:[driverModel]?)->Void){
   
        Alamofire.request(Config.ShowDrivers).responseJSON{response in
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
                
                var drivers = [driverModel]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = driverModel.init(dic: data) {
                        drivers.append(result)
                    }
                }
                completion(nil,drivers)
            }
            
        }
    }
    
    
    
    
    
}
