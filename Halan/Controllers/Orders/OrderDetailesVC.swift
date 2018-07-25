
import UIKit
import Kingfisher
class OrderDetailesVC: UIViewController {
    var dataarr:ordersModel?
    @IBOutlet var photo: UIImageView!
    @IBOutlet var DateAdd: UILabel!
    @IBOutlet var Destination: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var clientName: UILabel!
    @IBOutlet var cost: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var detailes: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photo.image =  #imageLiteral(resourceName: "user-avatar")
        self.photo.kf.indicatorType = .activity
        if let url = URL(string: (dataarr?.client_photo)!){
            self.photo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "user-avatar"), options: [.transition(ImageTransition.flipFromTop(0.5))], progressBlock: nil, completionHandler: nil)
        }
        
        
        DateAdd.text = dataarr?.order_date
        Destination.text = dataarr?.client_location
        location.text = dataarr?.market_location
        clientName.text = dataarr?.client_name
        cost.text = (dataarr?.cost)! + NSLocalizedString(" SR", comment: "Reial")
        phone.text = dataarr?.client_phone
        email.text = dataarr?.client_email
        detailes.text = dataarr?.order_details
    }


}
