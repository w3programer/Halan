import Foundation
import Alamofire
import SwiftyJSON
extension Api{
    class func BankAccountsApi(completion:@escaping (_ error:Error?, _ data:[BankAccounts]?)->Void){
        Alamofire.request(Config.bankAccounts).responseJSON{response in
            switch response.result
            {
            case.failure(let error):
                completion(error,nil)
                print(error)
            case.success(let value):
                let json = JSON(value)
                guard let dataArr = json.array else{
                    completion(nil , nil)
                    return
                }
                var Accounts = [BankAccounts]()
                for data in dataArr {
                    if let data = data.dictionary ,let result = BankAccounts.init(dic: data) {
                        Accounts.append(result)
                    }  
                }
                completion(nil,Accounts)
            }
            
        }
    }
}
