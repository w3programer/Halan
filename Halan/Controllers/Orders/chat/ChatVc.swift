
import UIKit
class ChatVc: UIViewController {

    @IBOutlet var chatTable: UITableView!
    @IBOutlet var clientChatHed: UINavigationItem!
    @IBOutlet var chatText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func sendMessage(_ sender: UIButton) {
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
    }
    
}
//extension ChatVc :UITableViewDataSource,UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}
