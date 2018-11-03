import UIKit
import Kingfisher
class ChatVc: UIViewController {
var chatarr = [chatModel]()
    @IBOutlet var chatTable: UITableView!
    @IBOutlet var clientChatHed: UINavigationItem!
    @IBOutlet var chatText: UITextField!
    var roomId:String = "0"
    var toid:String = "0"
    var images = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadtableData()
        //print("this is room id \(roomId)")
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        
        guard let messagetxt = chatText.text,!messagetxt.isEmpty else {return}
        Api.sendmessage(roomid:roomId,from_id:Helper.getuserid() , to_id: toid, message_type: "text", message: messagetxt, image: [""]) { (error:Error?, success:Bool) in
            if success{
                print("done")
            }else{
                print(error as Any)
            }
        }
   self.refreshtable()
        
    }
    var picker_image : UIImage?{
        didSet{
            guard let image = picker_image else{return}
            self.images.append(image.encodeimage(format:ImageFormat.JPEG(0) ))
        }
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        let picker  = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate =  self
        self.present(picker,animated: true,completion: nil)
        Api.sendmessage(roomid:roomId,from_id:Helper.getuserid() , to_id: toid, message_type: "image", message: "", image: images) { (error:Error?, success:Bool) in
            if success{
                print("done")
            }else{
                print(error as Any)
            }
        }
        
        
        
        self.refreshtable()
        
    }
    
    
    
    func refreshtable()  {
        DispatchQueue.main.async {
            self.loadtableData()
            self.chatText.text = ""
            self.chatTable.beginUpdates()
            self.chatTable.reloadRows(at: self.chatTable.indexPathsForVisibleRows!, with: .none)
            self.chatTable.endUpdates()
        }
    }
    
}
extension ChatVc :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedimage = info[UIImagePickerController.InfoKey.editedImage] as?UIImage{
           self.picker_image = editedimage
        }else if let orignalimage = info[UIImagePickerController.InfoKey.originalImage]{
            self.picker_image = (orignalimage as! UIImage)
            
        }
        picker.dismiss(animated: true, completion: nil)

        
    }
   
}
extension ChatVc :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatarr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTable.dequeueReusableCell(withIdentifier: "ChatCell" ,for: indexPath) as! ChatCell
        let fromtype = chatarr[indexPath.row].from_type
        let message_type = chatarr[indexPath.row].message_type
        if message_type == "image"{
          let urlString = chatarr[indexPath.row].image
            print(urlString)
          let url = URL(string: urlString )
            if url != nil {
                cell.imageView!.downloadedFrom(url: url!)

            }
        }
            else{
            cell.textLabel?.text = chatarr[indexPath.row].message

        }
        if fromtype == "2"{
            cell.textLabel?.textAlignment = NSTextAlignment.right
            cell.textLabel?.numberOfLines = 0

        }
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
       

        func loadtableData() {
            self.chatTable.rowHeight = UITableView.automaticDimension
            self.chatTable.estimatedRowHeight = 300
            Api.chatApi(romId: roomId) { (error:Error?,data:[chatModel]?) in
                self.chatarr = data!
                self.chatTable.reloadData()
            }
            
        }



    
    

}

