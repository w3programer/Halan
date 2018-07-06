import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Font_Awesome_Swift
import SwiftyJSON
import Alamofire
class HomeVC: UIViewController , UISearchBarDelegate , LocateOnTheMap,GMSAutocompleteFetcherDelegate ,GMSMapViewDelegate,CLLocationManagerDelegate{
///outlet
    @IBOutlet var NavmenuLeading: NSLayoutConstraint!
    @IBOutlet var NavView: UIView!
    @IBOutlet var menuButton: UIBarButtonItem!

    
    @IBOutlet var MuteSwich: UISwitch!
    
    
    @IBOutlet var ProfileImage: UIImageView!
    @IBOutlet var ProfileName: UIButton!
    var ordertitle:UITextField?

    @IBOutlet var OrderView: UIView!

    @IBOutlet var OrderButtomConstrain: NSLayoutConstraint!
    var googleMapsView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    var routes = [JSON]()
    var direction = [Direction]()
    var directionresult:Direction?
    let destinationmarker = GMSMarker()
    let locationmarker = GMSMarker()
    let polyline = GMSPolyline.init(path: nil)
    var distance = ""
    var duration = ""
    var startlocation = ""
    var endlocation = ""
    var dataarray = [String]()
    let locationmanager = CLLocationManager()
        var location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.navigationController?.tabBarItem.badgeValue = "6"
       // self.navigationController?.tabBarItem.badgeColor = .red
        let userdata =  Helper.getdata()
        let urlString = Config.uploads+userdata["user_photo"]!
        let url = URL(string: urlString )
        ProfileImage.downloadedFrom(url: url!)
        ProfileName.setTitle(userdata["user_name"], for: .normal)
        
        NavmenuLeading.constant =  -300
        OrderButtomConstrain.constant = 200
         self.menuButton.setFAIcon(icon: .FANavicon, iconSize: 35)
       
        self.destinationmarker.map = nil
        self.locationmarker.map = nil
        self.polyline.map = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.locationmanager.requestAlwaysAuthorization()
        self.locationmanager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationmanager.delegate = self
            locationmanager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationmanager.startMonitoringSignificantLocationChanges()
            locationmanager.startUpdatingLocation()
            
        }
        let camera = GMSCameraPosition.camera(withLatitude: 43, longitude: -77, zoom: 14)
        self.googleMapsView = GMSMapView.map(withFrame:self.view.bounds,camera:camera)
        googleMapsView.delegate = self
        self.googleMapsView.isMyLocationEnabled = true
        self.googleMapsView.settings.myLocationButton = true
        self.googleMapsView.settings.compassButton = true
        self.googleMapsView.settings.zoomGestures = true
        self.view.addSubview(self.googleMapsView)
        self.view.insertSubview(NavView, aboveSubview: self.googleMapsView)
        self.view.insertSubview(OrderView, aboveSubview: self.googleMapsView)


        /////add my location marker
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
  
    }
    
    
    //////////maps delegate
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
       
        
        let position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        self.destinationmarker.position = position
        self.destinationmarker.title = title
        self.destinationmarker.icon =     UIImage.init(icon:.FAMapMarker, size: CGSize(width: 75, height: 120), textColor: .red)
       
        let startlocation = CLLocation(latitude:self.location.latitude , longitude:self.location.longitude )
        let destination = CLLocation(latitude:coordinate.latitude , longitude:coordinate.longitude)
        self.drawPath(startLocation: startlocation, endLocation: destination)
      let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 15)

       self.googleMapsView.animate(to: camera)
        self.destinationmarker.map = self.googleMapsView
   
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = manager.location!.coordinate
        self.locationmarker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        self.locationmarker.title = NSLocalizedString("me", comment: "your location")
        self.locationmarker.snippet = NSLocalizedString("your current location here", comment: "location")
        self.locationmarker.icon =     UIImage.init(icon:.FAMapMarker, size: CGSize(width: 75, height: 100), textColor: .red)
        
        self.locationmarker.map = self.googleMapsView
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 14)
        self.googleMapsView.camera = camera

        locationmanager.stopUpdatingLocation()

    }
    
    /**
     * Called when an autocomplete request returns an error.
     * @param error the error that was received.
     */
    public func didFailAutocompleteWithError(_ error: Error) {
        //        resultText?.text = error.localizedDescription
        print(error.localizedDescription)
    }
    
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction?{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
      //print(resultsArray)
    }

    
    /**
     action for search location by address
     
     - parameter sender: button search location
     */
    
    @IBAction func searchWithAddress(_ sender: AnyObject) {
      
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated:true, completion: nil)
    }
    
    /**
     Locate map with longitude and longitude after search location on UISearchBar
     
     - parameter lon:   longitude location
     - parameter lat:   latitude location
     - parameter title: title of address location
     */
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            // self.googleMapsView.clear()
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15)
            self.destinationmarker.position = position
            self.destinationmarker.title = title
            self.destinationmarker.icon =     UIImage.init(icon:.FAMapMarker, size: CGSize(width: 75, height: 120), textColor: .red)
            let startlocation = CLLocation(latitude:self.location.latitude , longitude:self.location.longitude )
            let destination = CLLocation(latitude:lat , longitude:lon)
            self.drawPath(startLocation: startlocation, endLocation: destination)
            self.googleMapsView.animate(to: camera)
            self.destinationmarker.map = self.googleMapsView
            
        }
    }
   ///
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        Alamofire.request(url).responseJSON { response in
            let json = try? JSON(data: response.data!)
            //let routes = json!["routes"].arrayValue
            self.routes = json!["routes"].arrayValue
            // print route using Polyline
            for route in self.routes
            {
                            let legs = route["legs"].arrayValue
                            for data in legs{
                                self.distance = data["distance"]["value"].stringValue
                                self.duration = data["duration"]["text"].stringValue
                                self.endlocation = data["end_address"].stringValue
                                self.startlocation = data["start_address"].stringValue
                            }

                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                self.polyline.path = path
                self.polyline.strokeWidth = 4
                self.polyline.strokeColor = UIColor.red
                self.polyline.map = self.googleMapsView
                
            }
            //OrderPopUp
          self.ordermenu()
        }
    }
    
/////////////////////////////////////////
    func ordermenu(){

        UIView.animate(withDuration: 0.3, animations: {
            self.OrderButtomConstrain.constant = 0
            self.view.layoutIfNeeded()
            
        })    }
    
    @IBOutlet var OrderText: UITextField!
    
    @IBAction func Addordertocaret(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.OrderButtomConstrain.constant = 200
            self.view.layoutIfNeeded()
            
        })
        popup()

        print(OrderText.text ??  "null")
        
    }
    
    @IBAction func Cancelorder(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.2, animations: {
            self.OrderButtomConstrain.constant = 200
            self.view.layoutIfNeeded()
            
        })
    }
    
    
    
    
    
    
    
    
    
    func actionform() {
        
     let alertcontroller = UIAlertController(
        title: NSLocalizedString("ask Halan for you order", comment: "?"), message: nil, preferredStyle: .alert
        )
        alertcontroller.addTextField(configurationHandler:ordertextfiled)
        let txtaction = UIAlertAction(title: NSLocalizedString("Next", comment: "")
            , style:.default,
              handler: self.addorder)
        let cancelaction = UIAlertAction(title: NSLocalizedString("cancel", comment: "")
            , style:.destructive,
              handler: nil)
        alertcontroller.addAction(txtaction)
           alertcontroller.addAction(cancelaction)
        self.present(alertcontroller, animated: true, completion: nil)
    }
    func ordertextfiled(textfiled:UITextField)  {
        ordertitle = textfiled
        ordertitle?.placeholder = NSLocalizedString("add your order here", comment: "")
        
    }
    
    func addorder(alert:UIAlertAction)  {
        print(ordertitle?.text ?? "order is nill")
    }
  
    
    func popup(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupOrder") as! PopUpViewController
        self.addChildViewController(popOverVC)
        // popOverVC.view.frame = self.view.frame
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if resultsArray.count > 0{
            resultsArray.removeAll()
        }
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
   //////slide menu
    var isnaveopen = true
    @IBAction func NavigationButton(_ sender: UIBarButtonItem) {
        
        if isnaveopen {
         isnaveopen =  false
            self.menuButton.setFAIcon(icon: .FAClose, iconSize: 35)
            NavView.layer.shadowColor = UIColor.black.cgColor
            NavView.layer.shadowOpacity = 0.5
            NavView.layer.shadowOffset = CGSize(width: 25, height: 0)
            NavmenuLeading.constant = 0
        }else{
            NavmenuLeading.constant = -300
            self.menuButton.setFAIcon(icon: .FANavicon, iconSize: 35)
            isnaveopen =  true
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })

        
    }

    @IBAction func gesturerec(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed{
           let translation = sender.translation(in: self.view).x
            
            if translation > 0 {
                //swipe right
                if NavmenuLeading.constant < 20{
                    self.menuButton.setFAIcon(icon: .FAClose, iconSize: 35)
                    isnaveopen =  false

                    UIView.animate(withDuration: 0.2, animations: {
                        self.NavmenuLeading.constant += translation/10
                        self.view.layoutIfNeeded()

                    })

                }
                
            }else{
                ////swipe left
                
                if NavmenuLeading.constant > -300{
                    self.menuButton.setFAIcon(icon: .FANavicon, iconSize: 35)
                    isnaveopen =  true

                    UIView.animate(withDuration: 0.2, animations: {
                        self.NavmenuLeading.constant += translation/10
                        self.view.layoutIfNeeded()
                        
                    })
                    
                }
                
                
            }
            
            
            
        }else if sender.state == .ended {
            if NavmenuLeading.constant < -300{
                UIView.animate(withDuration: 0.2, animations: {
                    self.NavmenuLeading.constant = -300
                    self.view.layoutIfNeeded()
                    
                })
            }else{
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.NavmenuLeading.constant = 0
                    self.view.layoutIfNeeded()
                    
                })
                
            }
        }
    }
    @IBAction func MuteAction(_ sender: UISwitch) {
        if MuteSwich.isOn {


print("on")
        }else{
            print("off")

        }
    }
    
    

    
    @IBAction func Profile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ProfileSegue", sender: self)
    }
    
    @IBAction func registDriver(_ sender: UIButton) {
        
    }
    
    @IBAction func LogOut(_ sender: UIButton) {
      Helper.logout()

    }
    
 
    
}

