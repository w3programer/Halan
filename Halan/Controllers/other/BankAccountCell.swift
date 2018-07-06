
import UIKit

class BankAccountCell: UITableViewCell {

    @IBOutlet var accountname: UILabel!
    @IBOutlet var accountIban: UILabel!
    @IBOutlet var bankname: UILabel!
    @IBOutlet var accountnumber: UILabel!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
