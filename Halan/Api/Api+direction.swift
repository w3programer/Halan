import Foundation
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON
extension Api{
    class func drawPath(startLocation: CLLocation, endLocation: CLLocation,map:GMSMapView,completion:@escaping (_ error:Error?)->Void){
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        Alamofire.request(url).responseJSON { response in
            let json = try? JSON(data: response.data!)
           let routes = json!["routes"].arrayValue
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path:path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = map
            }

        }
        
}
}
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

