
import UIKit

class NotiViewCell: UITableViewCell {

    @IBOutlet var cost: UILabel!
    
    @IBOutlet var Topoint: UILabel!
    @IBOutlet var Dateadd: UILabel!
    
    
    @IBOutlet var FromPoint: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
