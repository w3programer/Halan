import UIKit
import Font_Awesome_Swift
class MeVC: UIViewController {
    @IBOutlet var Photo: UIImageView!
    @IBOutlet var Rules: UIImageView!
    @IBOutlet var Complainet: UIImageView!
    @IBOutlet var Pay: UIImageView!
    @IBOutlet var Share: UIImageView!
    @IBOutlet var Policy: UIImageView!
    @IBOutlet var About: UIImageView!
    @IBOutlet var Help: UIImageView!
    @IBOutlet var Rate: UIImageView!
    var urltext = ""
    var titlestr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let userdata =  Helper.getdata()
        let urlString = Config.uploads+userdata["user_photo"]!
        let url = URL(string: urlString )
        Photo.downloadedFrom(url: url!)
        Rules.setFAIconWithName(icon: .FABook, textColor: .green)
        Complainet.setFAIconWithName(icon: .FAWpforms, textColor: .green)
        Pay.setFAIconWithName(icon: .FAMoney, textColor: .green)
        Share.setFAIconWithName(icon: .FAShareAlt, textColor: .green)
        Policy.setFAIconWithName(icon: .FANewspaperO, textColor: .green)
        About.setFAIconWithName(icon: .FAExclamation, textColor: .green)
        Help.setFAIconWithName(icon: .FAQuestion, textColor: .green)
        Rate.setFAIconWithName(icon: .FAStarO, textColor: .green)

    }
    
    @IBAction func Rules(_ sender: UIButton) {
        self.titlestr = "Rules"
        self.urltext = Config.Rules
        self.performSegue(withIdentifier: "PrivacySegue", sender: self)

    }
    
    @IBAction func Complain(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ComplainSegue", sender: self)
    }
    
    @IBAction func Pay(_ sender: UIButton) {
    }
    
    @IBAction func Share(_ sender: UIButton) {
        let text = NSLocalizedString("halan app in your service", comment: "share")
        let image = UIImage(named: "Mainlogo")
        let myWebsite = NSURL(string:"https://itunes.apple.com/us/app/halan/id1364446659?ls=1&mt=8")
        let shareAll = [text , image! , myWebsite ?? "logo"] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    @IBAction func Policy(_ sender: UIButton) {
        self.titlestr = "Privacy policy"
        self.urltext = Config.Privacypolicy

        self.performSegue(withIdentifier: "PrivacySegue", sender: self)

    }
    
    
    @IBAction func About(_ sender: UIButton) {
        self.titlestr = "About App"
        self.urltext = Config.AboutApp

        self.performSegue(withIdentifier: "PrivacySegue", sender: self)

    }
    @IBAction func Help(_ sender: UIButton) {
        
        
    }
    @IBAction func Rate(_ sender: UIButton) {
       AppDelegate.rateApp()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PrivacySegue" {
            let destinationVC = segue.destination as! PrivacyVC
            destinationVC.titlestr = self.titlestr
            destinationVC.baseurl = self.urltext
        }
    }
}
