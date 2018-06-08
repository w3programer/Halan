import UIKit
class LoginVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
     //AppDelegate.requestReview()
    }
   
    @IBAction func Registration(_ sender: Any) {
        
        self.performSegue(withIdentifier: "RegistrationSegue", sender: self)
    }
    
}

