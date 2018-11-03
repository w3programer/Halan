import UIKit
import Font_Awesome_Swift
class RegistartionVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imagepicker:UIImagePickerController!
    let genderArr = [NSLocalizedString("Mail", comment: ""),NSLocalizedString("Femail", comment: "")]
    var pickerview = UIPickerView()
    @IBOutlet var UserImage: UIImageView!
    @IBOutlet var Name: UITextField!
    @IBOutlet var Phone: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var Age: UITextField!
    @IBOutlet var gender: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var repetPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserImage.image = UIImage(named: "user-avatar")
        gender.inputView = pickerview
        pickerview.dataSource = self
        pickerview.delegate = self
        imagepicker = UIImagePickerController()
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate = self
        textfiledimage()
    }
    
    @IBAction func register(_ sender: UIButton) {
        guard let name = Name.text,!name.isEmpty else {return}
        guard let username = username.text,!username.isEmpty else{return}
        guard let phone = Phone.text?.replacedArabicDigitsWithEnglish,!phone.isEmpty else{return}
        guard let Email = email.text,!Email.isEmpty else{return}
        //guard let age = Age.text,!age.isEmpty else{return}
       // guard let gender = gender.text,!gender.isEmpty else{return}
        guard let Password = password.text,!Password.isEmpty else{return}
        guard let passwordrepeet = repetPassword.text,!passwordrepeet.isEmpty,passwordrepeet == Password   else{
            let title:String = NSLocalizedString("report", comment: "")
            let message:String = NSLocalizedString("can not match password ", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
            self.present(alert,animated: true)

            return
            
        }
        var age = "0"
        if !(Age.text?.replacedArabicDigitsWithEnglish.isEmpty)!{
            age = Age.text!
        }
        var Gender = "non"

        if !(gender.text?.isEmpty)!{
            Gender = gender.text!
        }
        
        Api.registration(username:username ,password:Password ,email:Email,phone:phone,fullname:name,age:age,gender:Gender,photo:UserImage.image!.encodeimage(format: ImageFormat.JPEG(0)),token:Helper.getdevicestoken(), completion: { (error:Error?, success :Bool) in
            
            
            if success {
                
                let title:String = NSLocalizedString("message title", comment: "")
                let message:String = NSLocalizedString("message body", comment: "")
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert,animated: true)
                
            }else{
                let title:String = NSLocalizedString("loginmessagehead", comment: "")
                let message:String = NSLocalizedString("connectionbody", comment: "")
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
                self.present(alert,animated: true)
                
            }
        })
   
    }
    
    @IBAction func login(_ sender: UIButton) {
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    

    @IBAction func SelectImage(_ sender: UIButton) {
     self.present(imagepicker, animated: true, completion: nil)
    }
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as?UIImage{
            UserImage.image = image
        }
    
    
    if let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
        UserImage.image = editedImage
    } else if let originalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
        UserImage.image = originalImage
    }
        imagepicker.dismiss(animated: true, completion: nil)
    }
    
    func textfiledimage() {
        Name.setLeftViewFAIcon(icon: .FAUserO, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)

        Phone.setLeftViewFAIcon(icon: .FAMobilePhone, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)
        email.setLeftViewFAIcon(icon: .FAEnvelope, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)
        Age.setLeftViewFAIcon(icon: .FAUserTimes, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)
        gender.setLeftViewFAIcon(icon: .FAMale, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)
        username.setLeftViewFAIcon(icon: .FAUserO, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)
        password.setLeftViewFAIcon(icon: .FALock, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)
        repetPassword.setLeftViewFAIcon(icon: .FALock, leftViewMode: .always, textColor: .green, backgroundColor: .clear, size: nil)

        
        
    }
    
    
    
}
/////////picker view
extension RegistartionVC :UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArr[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender.text = genderArr[row]
        gender.resignFirstResponder()
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
