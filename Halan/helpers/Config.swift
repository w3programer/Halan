import Foundation
struct Config {
    static let main = "http://halan.net/"
    static let registration = main + "Api/ClientRegistration/"
    static let login = main + "Api/Login/"
    //Logout
    static let Logout = main + "Api/Logout/"
    static let ResetePassword = main + "Api/RestMyPass/"
    //profile
    static let profile = main + "Api/ClientProfile/"
    //convert user to driver
    static let DriverRegistration = main + "Api/DriverRegistration/"
    //UpdateLocation for driver
    static let updateDriverLocation = main + "Api/UpdateLocation/\(Helper.getuserid)"
    //update token id
    static let UpdateTokenId = main + "Api/UpdateTokenId/"
    ///UpdateClient
    static let UpdateClient = main + "Api/UpdateClient/"
    ///UpdateDriver
    static let UpdateDriver = main + "Api/UpdateDriver/"
    //ShowDrivers
    static let ShowDrivers = main + "Api/ShowDrivers/"
    //DestanceCost
    static let DestanceCost = main + "Api/DestanceCost/"
    //addMyOrder
    static let AddMyOrder = main + "Api/AddMyOrder/"
    //driver orders
    static let viewdriverOrder = main + "Api/ViewDriverOrders/"
    static let driverCancelOrder = main + "Api/DriverCancelOrder/\(Helper.getuserid())"
    static let orderDelivered = main + "Api/OrderDelivered/"
    //client orders
    static let viewClientOrder = main + "Api/ViewClientOrders/"
    
    //ReceivedRequests
    static let ReceivedRequests = main + "Api/ReceivedRequests/"
    //DriverAction
    static let DriverAction = main + "Api/DriverAction/"
    //ShowMyRequests
    static let ClientRequests = main + "Api/ShowMyRequests/\(Helper.getuserid())"
    static let driverRequests = main + "Api/ReceivedRequests/\(Helper.getuserid())"
    //orders
    static let clientCancerOrder = main + "Api/ClientCancelOrder/\(Helper.getuserid())"

    //contactus
    static let Contactus = main + "Api/ContactUs/"
    static let AboutApp = main + "Api/AboutApp/"
    static let Privacypolicy = main + "Api/PolicyApp/"
    static let Rules = main + "Api/TermsAndConditions/"
    static let bankAccounts = main + "Api/BankAccounts/"
    //uploads path
    static let uploads = main + "uploads/images/"
    
}
