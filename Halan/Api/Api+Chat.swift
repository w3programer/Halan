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
    
    class func sendmessage(roomid:String,
        from_id:Int , to_id:String,message_type:String  ,message:String,image:[String],completion:@escaping(_ error :Error? ,_ success :Bool)->Void){
        let BaseUrl = Config.sendMessage+roomid
        let parameters = [
            "from_id":from_id,
            "to_id":to_id,
            "message":message,
            "message_type": message_type,
            "image":image,
            ] as [String : Any]
/////////////////////////////////////////
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

        
        
        
///////////////
        
        
        
    }
    


