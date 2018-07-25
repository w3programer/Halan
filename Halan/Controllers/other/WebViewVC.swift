
import UIKit
import WebKit
class WebViewVC: UIViewController {
    var urlstr = ""
    var titlestr = ""
    @IBOutlet var NaveTitle: UINavigationItem!
    @IBOutlet var WebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NaveTitle.title = self.titlestr
        let myURL = URL(string: self.urlstr)
        let myRequest = URLRequest(url: myURL!)
        WebView.load(myRequest)


    }

}
