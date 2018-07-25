import UIKit
import Font_Awesome_Swift
class ForgetPassVC: UIViewController {
    @IBOutlet var Email: UITextField!
    @IBOutlet var userName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Email.setLeftViewFAIcon(icon: .FAEnvelopeO, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)
        userName.setLeftViewFAIcon(icon: .FAUserO, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)

    }

    @IBAction func Reset(_ sender: UIButton) {
        Api.ReseetPassword(username: userName.text!, email: Email.text!) { (error:Error?, success :Bool) in
            if success {
                let title:String = NSLocalizedString("report", comment: "")
                let message:String = NSLocalizedString("success", comment: "")
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert,animated: true)

                
            }else{
                let title:String = NSLocalizedString("report", comment: "")
                let message:String = NSLocalizedString("failed", comment: "")
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
                self.present(alert,animated: true)
                
            }
        }
        
    }
    
}
