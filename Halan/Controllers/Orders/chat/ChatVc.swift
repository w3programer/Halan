
import UIKit
class ChatVc: UIViewController {
var chatarr = [chatModel]()
    @IBOutlet var chatTable: UITableView!
    @IBOutlet var clientChatHed: UINavigationItem!
    @IBOutlet var chatText: UITextField!
    var roomId:String = "0"
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadtableData()
        //print("this is room id \(roomId)")
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
    }
    
}
extension ChatVc :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTable.dequeueReusableCell(withIdentifier: "ChatCell" ,for: indexPath) as! ChatCell
       // cell.orderDate.text = orders[indexPath.row].order_start_from_minute
        
        let leftImage = UIImageView(image: #imageLiteral(resourceName: "user-avatar"));
        leftImage.frame = CGRect(x:0,y:0,width:100,height:100)

        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 300.0, height: 100.0)
        let leftLable = UILabel(frame: CGRect(x:0,y:0,width: 200, height:50))
        leftLable.text = chatarr[indexPath.row].message
          print(chatarr[indexPath.row].message)
       // leftView.addSubview(leftImage)
       // leftView.addSubview(leftLable)
        cell.container.addSubview(leftImage)

        cell.container.addSubview(leftLable)

        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    func loadtableData() {
        self.chatTable.rowHeight = UITableViewAutomaticDimension
        self.chatTable.estimatedRowHeight = 300
        Api.chatApi(romId: roomId) { (error:Error?,data:[chatModel]?) in
            self.chatarr = data!
            self.chatTable.reloadData()
        }
    
        
    }
    
}
