import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import Foundation
class messageconfig {
    class func getDevicetoken()->String {
        let token = Messaging.messaging().fcmToken
        return token!
    }

}
