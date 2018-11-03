import UIKit
import MapKit
import Font_Awesome_Swift
class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}
class NotifactionsDetailes: UIViewController , MKMapViewDelegate{
    var dataarr:Notifactions?
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var Titlehead: UINavigationItem!
    @IBOutlet var To: UILabel!
    @IBOutlet var from: UILabel!
    @IBOutlet var orderDetailes: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var Cost: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.isZoomEnabled = true
        self.direction()

        self.results()
    }
    
    func direction(){
        // Do any additional setup after loading the view, typically from a nib.
        let sourceLocation = CLLocationCoordinate2D(latitude:(dataarr?.client_google_lat)! , longitude: (dataarr?.client_google_lang)!)
        let destinationLocation = CLLocationCoordinate2D(latitude:(dataarr?.market_google_lat)! , longitude: (dataarr?.market_google_lang)!)
        
        let sourcePin = customPin(pinTitle: (dataarr?.client_location)!, pinSubTitle: "", location: sourceLocation)
        let destinationPin = customPin(pinTitle: (dataarr?.market_location)!, pinSubTitle: "", location: destinationLocation)
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
    
        //let directions = MKDirections(request: directionRequest)
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion.init(rect), animated: true)
        }
        

    }
    
    //MARK:- MapKit delegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
    func results(){
    self.Cost.text = dataarr?.order_driver_cost
        self.phone.text = dataarr?.client_phone
        self.orderDetailes.text = dataarr?.order_details
        self.from.text = dataarr?.client_location
        self.To.text = dataarr?.market_location
        self.Titlehead.title = dataarr?.client_name
    }
    
    
    @IBAction func Accept(_ sender: UIButton) {
        Api.driverAction(action: "1", messageid: (self.dataarr?.message_id)!, orderid: (self.dataarr?.order_id)!, clientid: (self.dataarr?.client_id_fk)!) { (error:Error?, success:Bool) in
            if success {
                
                let title:String = NSLocalizedString("report", comment: "")
                let message:String = NSLocalizedString("sucess ", comment: "")
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert,animated: true)
                
            }else{
                let title:String = NSLocalizedString("report", comment: "")
                let message:String = NSLocalizedString("error while executing your request", comment: "")
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
                self.present(alert,animated: true)
                
            }

        }

    }
    
    @IBAction func Refuse(_ sender: UIButton) {
        Api.driverAction(action: "2", messageid: (self.dataarr?.message_id)!, orderid: (self.dataarr?.order_id)!, clientid: (self.dataarr?.client_id_fk)!) { (error:Error?, success:Bool) in
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
        }


    }
    

}
