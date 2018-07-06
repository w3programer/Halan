import UIKit
import SwiftyJSON
class BankAccounts: NSObject {
    var account_name :String = ""
    var account_IBAN :String = ""
    var account_bank_name :String = ""
    var account_number :String = ""
    init?(dic:[String:JSON]) {
        guard let account_name = dic["account_name"]?.string , let account_number = dic["account_number"]?.string  else {
            return nil
        }
        self.account_name = account_name
        self.account_number = account_number

        self.account_IBAN = (dic["account_IBAN"]?.string)!
        self.account_bank_name = (dic["account_bank_name"]?.string)!
        
    }
    
    
    
    
    
    
    
    
    
}
