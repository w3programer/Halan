import UIKit
class BarCollectionViewCell: UICollectionViewCell {
    //MARK: Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bacView: UIView!
    //MARK: Internal Properties
    var titleString : String?{
        get{
            return self.titleLabel.text
        }
        set{
            self.titleLabel.text = newValue
        }
    }
    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                self.titleLabel.textColor = UIColor.red
                self.bacView.isHidden = false
            }
            else
            {
                self.titleLabel.textColor = UIColor.white
                self.bacView.isHidden = true
            }
        }
    } 
    //MARK: View Lifecycle Methods
    override func awakeFromNib()
    {
        self.titleLabel.text = nil
    }
}
