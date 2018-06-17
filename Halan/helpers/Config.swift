import Foundation
struct Config {
    static let main = "http://fekraapp.semicolonsoft.com/hala/"
    static let registration = main + "Api/ClientRegistration/"
    static let login = main + "Api/Login/"
    //Logout
    static let Logout = main + "Api/Logout/"
    //profile
    static let profile = main + "Api/ClientProfile/"
    //convert user to driver
    static let DriverRegistration = main + "Api/DriverRegistration/"
    //UpdateLocation
    static let UpdateLocation = main + "Api/UpdateLocation/"
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
    //AddMyOrder
    static let AddMyOrder = main + "Api/AddMyOrder/"
    //ReceivedRequests
    static let ReceivedRequests = main + "Api/ReceivedRequests/"
    //DriverAction
    static let DriverAction = main + "Api/DriverAction/"
    //ShowMyRequests
    static let ShowMyRequests = main + "Api/ShowMyRequests/"
    //uploads path
    static let uploads = main + "uploads/images/"
    
}
