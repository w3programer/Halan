
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
        if Helper.isguest() == false{
            Profile()
        }
    }
    
    
    func Profile(){
        Api.profile{(error: Error?,info:[ProfileData]?)in
            if let data = info {
                self.Username.text = data[0].user_name
                self.Name.text = data[0].user_full_name
                self.email.text = data[0].user_email
                self.Phone.text = data[0].user_phone
                       self.Photo.image =  #imageLiteral(resourceName: "user-placeholder")
                        self.Photo.kf.indicatorType = .activity
                        if let url = URL(string: data[0].user_photo){
                            self.Photo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "user-placeholder"), options: [.transition(ImageTransition.flipFromTop(0.5))], progressBlock: nil, completionHandler: nil)
                                                                     }
                       }
                    
                      }
    }
    @IBAction func changeImage(_ sender: UIButton) {
        self.present(imagepicker, animated: true, completion: nil)

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as?UIImage{
            self.Photo.image = image
            self.isselect = true
        }
        if let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            self.Photo.image = editedImage
            self.isselect = true

        } else if let originalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
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
        Api.updateprofile(name:Username.text!, username: Name.text!, phone: (Phone.text?.replacedArabicDigitsWithEnglish)!, email: email.text!, photo: photostring) { (error:Error?, success :Bool) in
            
            let title:String = NSLocalizedString("report", comment: "")
            let message:String = NSLocalizedString("updated success", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert,animated: true)
           
            self.view.setNeedsLayout()

            }
   
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
