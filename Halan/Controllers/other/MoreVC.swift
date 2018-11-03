
import UIKit
import Alamofire
import SwiftyJSON
class MoreVC: UIViewController , UITableViewDataSource,UITableViewDelegate{
    var titlestr = "";var weburl = "";var facebook = "";var twitter = "";var instigram = "";var watsapp = "";var google = "";var snapchat = "";var email = ""
    var tabledata = [BankAccounts]()
    @IBOutlet var BankTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.accountdata()
        self.BankTable.allowsSelection = false
        Alamofire.request(Config.Contactus).responseJSON{response in
            switch response.result
            {
            case.failure(let error):
                print(error)
            case.success(let value):
                let json = JSON(value)
                self.facebook = json["facebook_url"].object as! String
                self.twitter = json["twitter_url"].object as! String
                self.google = json["google_url"].object as! String
                self.instigram = json["instgram_url"].object as! String
                self.watsapp = json["our_phone_number"].object as! String
                self.email = json["email"].object as! String
                self.snapchat = json["snapchat_url"].object as! String
            }
        }
        
    }
    
    @IBAction func whatsapp(_ sender: UIButton) {
        let urlWhats = "whatsapp://send?phone=\(self.watsapp)?text=hello"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    UIApplication.shared.open(whatsappURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }


    }
    
    @IBAction func snapchat(_ sender: UIButton) {
        self.titlestr = NSLocalizedString("snapchat", comment: "whatsapp")
        self.weburl = self.snapchat
        self.performSegue(withIdentifier: "WebSegue", sender: self)

    }
    @IBAction func facebook(_ sender: UIButton) {
        
        self.titlestr = NSLocalizedString("facebook", comment: "whatsapp")
        self.weburl = self.facebook
        self.performSegue(withIdentifier: "WebSegue", sender: self)

        
    }
    @IBAction func twitter(_ sender: UIButton) {
        
        self.titlestr = NSLocalizedString("twitter", comment: "whatsapp")
        self.weburl = self.twitter
        self.performSegue(withIdentifier: "WebSegue", sender: self)

    }
    @IBAction func instigram(_ sender: UIButton) {
        self.titlestr = NSLocalizedString("instigram", comment: "whatsapp")
        self.weburl = self.instigram
        self.performSegue(withIdentifier: "WebSegue", sender: self)

    }
    @IBAction func email(_ sender: UIButton) {
        let url = NSURL(string: "mailto:\(self.email)")
        UIApplication.shared.open(url! as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)

    }
    @IBAction func google(_ sender: UIButton) {
        self.titlestr = NSLocalizedString("google", comment: "whatsapp")
        self.weburl = self.google
        self.performSegue(withIdentifier: "WebSegue", sender: self)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebSegue" {
            let destinationVC = segue.destination as! WebViewVC
            destinationVC.titlestr = self.titlestr
            destinationVC.urlstr = self.weburl
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabledata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCell" ,for: indexPath) as! BankAccountCell
       cell.selectionStyle = UITableViewCell.SelectionStyle.none

        cell.accountIban.text = tabledata[indexPath.row].account_IBAN
        cell.accountname.text = tabledata[indexPath.row].account_name

        cell.bankname.text = tabledata[indexPath.row].account_bank_name

        cell.accountnumber.text = tabledata[indexPath.row].account_number

        return cell
    }
    func accountdata(){
        Api.BankAccountsApi{(error :Error?, data: [BankAccounts]?) in
            self.tabledata = data!
            self.BankTable.reloadData()
            
        }
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
