import  UIKit
extension String{
    
    /// to delete withe space
    var trimmed: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

extension UIViewController {
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
extension UIView {
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func  fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
//scaleAspectFit
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
}
//Data:- base 64 encode
extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
public enum ImageFormat{
    case PNG
    case JPEG(CGFloat)
}
extension UIImage {
    public func encodeimage(format:ImageFormat)->String{
        var imageData:Data?
        switch format {
        case .PNG:imageData = UIImagePNGRepresentation(self)
        case .JPEG(let compression):imageData = UIImageJPEGRepresentation(self, compression)

        }
        return (imageData?.base64EncodedString())!
    }
 ///usage
    /*
     let image = UIImage(named:"swift-logo")
     let base64String = convertImageTobase64(format: .png, image: image!)
     

     */
    
    public func decodeimage(base64string:String)->UIImage{
        let imagedata = Data(base64Encoded: base64string)
        return UIImage(data: imagedata!)!
        
    }
}
import StoreKit
extension AppDelegate{
        class func rateApp(){
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {guard let url = URL(string: "itms-apps://itunes.apple.com/us/app/halan/id1364446659?mt=8&action=write-review") else {return}
                
                UIApplication.shared.openURL(url)

            }  
    }
}
extension UIViewController{
    func returnback() {
        
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}




