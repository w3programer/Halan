import UIKit
class Helper: NSObject {
    class func restartApp(){
        guard let window = UIApplication.shared.keyWindow else{return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc:UIViewController
        if getUserData() {
            vc = storyboard.instantiateViewController(withIdentifier: "Home")

        }else{
            
            vc = (storyboard.instantiateInitialViewController())!

        }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    class func setUserData(user_id : Int,user_email:String,user_name:String,user_phone:Int){
        let def = UserDefaults.standard
        def.setValue(user_id, forKey: "user_id")
        def.setValue(user_email, forKey: "user_email")
        def.setValue(user_name, forKey: "user_name")
        def.setValue(user_phone, forKey: "user_phone")
        def.synchronize()
        restartApp()
        
    }
    class func getUserData()->Bool{
        let def = UserDefaults.standard
        return (def.object(forKey: "user_email") as? String) != nil
        
    }
    class func getuserid()->Int{
        let def = UserDefaults.standard
        return (def.object(forKey: "user_id") as! Int)
    }

    class func logout(){
        let def = UserDefaults.standard
        def.removeObject(forKey: "user_email")
        restartApp()

    }
}
