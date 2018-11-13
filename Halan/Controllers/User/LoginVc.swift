import UIKit
import Font_Awesome_Swift
class LoginVC: UIViewController {
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //AppDelegate.requestReview()
       
        username.setLeftViewFAIcon(icon: .FAUserO, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)
        password.setLeftViewFAIcon(icon: .FALock, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)

    }
    @IBAction func Login(_ sender: UIButton) {
        guard let name = username.text,!name.isEmpty ,let pass = password.text,!pass.isEmpty else {
            
            let title:String = NSLocalizedString("report", comment: "")
            let message:String = NSLocalizedString("username or password is empty", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
            self.present(alert,animated: true)
            return
            
        }

        Api.login(username: name, password: pass) { (error:Error?, success :Bool) in
            if success {
                
                
            }else{
                let title:String = NSLocalizedString("report", comment: "")
                let message:String = NSLocalizedString("failed", comment: "")
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
                self.present(alert,animated: true)   
            }
        }
    }
    @IBAction func Registration(_ sender: Any) {

   self.performSegue(withIdentifier: "RegistrationSegue", sender: self)
    }
    
    @IBAction func reseetpassword(_ sender: Any) {
        self.performSegue(withIdentifier: "ForgetSegue", sender: self)
    }
    @IBAction func skip(_ sender: Any) {
        
        let def = UserDefaults.standard
        def.setValue(true, forKey: "guest")
       Helper.restartApp()
//    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Home") as? HomeVC
//       self.navigationController?.pushViewController(vc!, animated: true)
       // self.present(vc!,animated: true, completion: nil)
    }
    
}

