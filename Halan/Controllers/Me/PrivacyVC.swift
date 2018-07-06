
import UIKit
import SwiftyJSON
import Alamofire
class PrivacyVC: UIViewController {
    @IBOutlet var NaveTitle: UINavigationItem!
    @IBOutlet var TitleHead: UILabel!
    @IBOutlet var ContentBody: UITextView!
    var baseurl = ""
    var titlestr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       self.NaveTitle.title = NSLocalizedString(self.titlestr, comment: "privacy")
        Alamofire.request(self.baseurl).responseJSON{response in
            switch response.result
            {
            case.failure(let error):
                print(error)
            case.success(let value):
                let json = JSON(value)
                self.TitleHead.text = json["title"].object as? String
                self.ContentBody.text = json["content"].object as! String
            }
    }
  }
}
