import UIKit
import MapKit
import Font_Awesome_Swift
class CurentOrder: UIViewController,MKMapViewDelegate{
    
    var dataarr:ordersModel?
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
        
        let directionRequest = MKDirectionsRequest()
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
         self.mapView.add(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
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
        self.Cost.text = dataarr?.cost
        self.phone.text = dataarr?.client_phone
        self.orderDetailes.text = dataarr?.order_details
        self.from.text = dataarr?.client_location
        self.To.text = dataarr?.market_location
        self.Titlehead.title = dataarr?.client_name
    }
    @IBAction func finish(_ sender: UIButton) {
        Api.orderDelivered(orderid: (dataarr?.order_id)!) { (error:Error?, success:Bool) in 
        }
    }
    
    @IBAction func Refuse(_ sender: UIButton) {

        if Helper.isDriver() == true{
            Api.driverCancel(orderid: (dataarr?.order_id)!, clientid: (dataarr?.client_id_fk)!) { (error:Error?, success:Bool) in
            }
        }else{
          
            let alert = UIAlertController(title:NSLocalizedString("cancelltion Reasons", comment: "") , message: NSLocalizedString("Please Select an Option from this reasons", comment: "") , preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title:NSLocalizedString("Driver Delayed", comment: ""), style: .default , handler:{ (UIAlertAction)in
              self.cancellReport(reasonValue: "1")
            }))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel Order", comment: ""), style: .default , handler:{ (UIAlertAction)in
                self.cancellReport(reasonValue: "2")
            }))
            
            alert.addAction(UIAlertAction(title:NSLocalizedString("Other reasons", comment: "") , style: .destructive , handler:{ (UIAlertAction)in

                self.cancellReport(reasonValue: "3")

            }))
            
            alert.addAction(UIAlertAction(title:NSLocalizedString("Dismiss", comment: "") , style: .cancel, handler:{ (UIAlertAction)in
                self.trySendingOrder()

            }))
            
            self.present(alert, animated: true, completion: {
            })
  
        }
        

    }
    
    func cancellReport(reasonValue:String)  {
        Api.clientCancelorder(orderid: (self.dataarr?.order_id)!, driverid: (self.dataarr?.driver_id)!, reason: reasonValue) { (error:Error?, success:Bool) in
        }
      self.trySendingOrder()
    }
    func trySendingOrder() {
        let alert = UIAlertController(title:NSLocalizedString("More", comment: "") , message: NSLocalizedString("Send order to another driver", comment: ""), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:NSLocalizedString("yes", comment: "") , style: .default , handler:{ (UIAlertAction)in

           /////////////
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("No Thanks", comment: ""), style: .destructive , handler:{ (UIAlertAction)in

        }))
        
        alert.addAction(UIAlertAction(title:NSLocalizedString("Dismiss", comment: "") , style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })

    }
    @IBAction func chat(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ChatSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatSegue" {
            let destinationVC = segue.destination as! ChatVc
            destinationVC.clientChatHed.title = dataarr?.client_name
         //destinationVC.chatarr = dataarr
            destinationVC.roomId = (dataarr?.room_id)!
            //chatData
        }
    }
    
    
}














