import UIKit
class ContactUs: UIViewController {
    @IBOutlet var Name: UITextField!
    @IBOutlet var Email: UITextField!
    @IBOutlet var Subject: UITextField!
    @IBOutlet var Message: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func Send(_ sender: UIButton) {
        Api.ContactUs(name: Name.text!, email: Email.text!, message: Message.text!) {(error:Error?, success:Bool) in
            let title:String = NSLocalizedString("report", comment: "")
            let message:String = NSLocalizedString("message sent success", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert,animated: true)
            }
    }
}
