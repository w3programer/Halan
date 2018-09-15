import Foundation
import Alamofire
import SwiftyJSON
extension Api{
    class func chatApi(romId:String,completion:@escaping (_ error:Error?, _ data:[chatModel]?)->Void){
        Alamofire.request(Config.chatRoom+romId).responseJSON{response in
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
                print(error)
            case.success(let value):
                let json = JSON(value)
                print(json)
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var results = [chatModel]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = chatModel.init(dic: data) {
                        results.append(result)
                    }
                }
                completion(nil,results)
            }
            
        }
    }
}

