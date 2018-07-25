import UIKit
class OrderCell: UITableViewCell {
    @IBOutlet var client_location: UILabel!
    @IBOutlet var market_location: UILabel!

    @IBOutlet var cost: UILabel!
    @IBOutlet var orderDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
