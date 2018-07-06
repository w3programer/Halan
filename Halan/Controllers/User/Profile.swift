
import UIKit
import Kingfisher
class Profile: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var imagepicker:UIImagePickerController!

    @IBOutlet var Name: UILabel!
    @IBOutlet var Photo: UIImageView!
    @IBOutlet var Username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var Phone: UITextField!
    var isselect = false
    
    @IBOutlet var Password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagepicker = UIImagePickerController()
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate = self

        Profile()
    }
    
    
    func Profile(){
        Api.profile{(error: Error?,info:[ProfileData]?)in
            if let data = info {
                self.Username.text = data[0].user_full_name
                self.Name.text = data[0].user_name
                self.email.text = data[0].user_email
                self.Phone.text = data[0].user_phone
                       self.Photo.image =  #imageLiteral(resourceName: "user-avatar")
                        self.Photo.kf.indicatorType = .activity
                        if let url = URL(string: data[0].user_photo){
                            self.Photo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "user-avatar"), options: [.transition(ImageTransition.flipFromTop(0.5))], progressBlock: nil, completionHandler: nil)
                                                                     }
                       }
                    
                      }
    }
    @IBAction func changeImage(_ sender: UIButton) {
        self.present(imagepicker, animated: true, completion: nil)

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as?UIImage{
            self.Photo.image = image
            self.isselect = true
        }
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.Photo.image = editedImage
            self.isselect = true

        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.Photo.image = originalImage
            self.isselect = true

        }
        self.imagepicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func Update(_ sender: UIButton) {
        var photostring = ""
        if isselect == true {
             photostring = Photo.image!.encodeimage(format: ImageFormat.JPEG(0))

        }else{
           photostring = ""
        }
        Api.updateprofile(name:Username.text!, username: Name.text!, phone: Phone.text!, email: email.text!, photo: photostring) { (error:Error?, success :Bool) in
            
            let title:String = NSLocalizedString("report", comment: "")
            let message:String = NSLocalizedString("updated success", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert,animated: true)
           
            self.view.setNeedsLayout()

            }
   
    }
    
}
