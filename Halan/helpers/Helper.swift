import UIKit
class Helper: NSObject {
    class func restartApp(){
        guard let window = UIApplication.shared.keyWindow else{return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc:UIViewController
      
            if getUserData() || isguest() == true{
                vc = storyboard.instantiateViewController(withIdentifier: "Home")
            }else{
                vc = (storyboard.instantiateInitialViewController())!
            }
      
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    

    
    class func setUserData(user_id : Int,user_email:String,user_name:String,user_phone:Int,user_photo:String,user_type:String){
        let def = UserDefaults.standard
        def.setValue(user_id, forKey: "user_id")
        def.setValue(user_type, forKey: "user_type")
        def.setValue(user_email, forKey: "user_email")
        def.setValue(user_name, forKey: "user_name")
        def.setValue(user_phone, forKey: "user_phone")
        def.setValue(user_photo, forKey: "user_photo")
        def.synchronize()
        restartApp()
    }
    class func setDevicesToken(token:String){
        let def = UserDefaults.standard
        def.setValue(token, forKey: "token")

    }
   class func  remove_pref(remove_key : String){
        UserDefaults.standard.removeObject(forKey: remove_key)
        UserDefaults.standard.synchronize()
    }

    class func getdevicestoken()->String{
        let def = UserDefaults.standard
        return (def.object(forKey: "token") as? String)!
    }
    
    
    class func getUserType()->String{
        let def = UserDefaults.standard
        return (def.object(forKey: "user_type") as? String)!
        
    }
    class func isDriver()->Bool{
        let def = UserDefaults.standard
        if def.object(forKey: "user_type") != nil{
            let userType = (def.object(forKey: "user_type")as! NSString).integerValue
            if ( userType == 1){
                return true
            }else{
                return false
            }

        }
        return false
    }
    class func getUserData()->Bool{
        let def = UserDefaults.standard
        return (def.object(forKey: "user_email") as? String) != nil
        
    }
    class func getuserid()->Int{
        let def = UserDefaults.standard
        return (def.object(forKey: "user_id") as! Int)
    }
    class func getuserphone()->String{
        let def = UserDefaults.standard
        return (def.object(forKey: "user_phone") as! String)
    }
    class func getdata()->Dictionary<String,String>{
        let def = UserDefaults.standard
       
        let data:[String:String] = [
           
            "user_email":def.object(forKey: "user_email") as!String ,
            "user_name":def.object(forKey: "user_name")as!String,
                "user_photo":def.object(forKey: "user_photo") as!String,
            ]
        
        return data
    }
    class func logout(){
        let def = UserDefaults.standard
        def.removeObject(forKey: "user_email")
        def.removeObject(forKey: "guest")
        restartApp()

    }
    class func isguest( )->Bool{
        let def = UserDefaults.standard
        return (def.object(forKey: "guest") != nil)
    }
}
