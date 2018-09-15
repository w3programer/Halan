import UIKit;import GoogleMaps;import GooglePlaces;import CoreLocation
;import Font_Awesome_Swift;import SwiftyJSON;import Alamofire
class HomeVC: UIViewController , UISearchBarDelegate , LocateOnTheMap,GMSAutocompleteFetcherDelegate ,GMSMapViewDelegate,CLLocationManagerDelegate{
    @IBOutlet var NavmenuLeading: NSLayoutConstraint!
    @IBOutlet var NavView: UIView!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var MuteSwich: UISwitch!
    @IBOutlet var ProfileImage: UIImageView!
    @IBOutlet var ProfileName: UIButton!
    @IBOutlet var OrderView: UIView!
    @IBOutlet var OrderButtomConstrain: NSLayoutConstraint!
    @IBOutlet var clientLocation: UILabel!
    @IBOutlet var MarketLocation: UILabel!
    @IBOutlet var WayCost: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var orderFinalsend: UIView!
    @IBOutlet var orderButtomConst: NSLayoutConstraint!
    var isnaveopen = true
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
    var dataarray = [String]()
    var driverArr = [String]()
    var destinationmarket = CLLocation()
    
    var distanceCost = ""
    let locationmanager = CLLocationManager()
    var location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
      var marketDestination:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        let userdata =  Helper.getdata()
        let urlString = Config.uploads+userdata["user_photo"]!
        let url = URL(string: urlString )
        ProfileImage.downloadedFrom(url: url!)
        ProfileName.setTitle(userdata["user_name"], for: .normal)
        NavmenuLeading.constant =  -300
        OrderButtomConstrain.constant = 200
        self.orderButtomConst.constant = 300
         self.menuButton.setFAIcon(icon: .FANavicon, iconSize: 35)
        self.destinationmarker.map = nil
        self.locationmarker.map = nil
        self.polyline.map = nil
    }
    //////////maps delegate
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        self.destinationmarker.position = position
        self.destinationmarker.title = title
        self.destinationmarker.icon =     UIImage.init(icon:.FAMapMarker, size: CGSize(width: 75, height: 120), textColor: .red)
        let startlocation = CLLocation(latitude:self.location.latitude , longitude:self.location.longitude )
        let destination = CLLocation(latitude:coordinate.latitude , longitude:coordinate.longitude)
        self.marketDestination.longitude = coordinate.longitude
        self.marketDestination.latitude = coordinate.latitude

        self.drawPath(startLocation: startlocation, endLocation: destination)
      let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 15)
       self.googleMapsView.animate(to: camera)
        self.destinationmarker.map = self.googleMapsView
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
            self.marketDestination.longitude = lon
            self.marketDestination.latitude = lat

            self.drawPath(startLocation: startlocation, endLocation: destination)
            self.googleMapsView.animate(to: camera)
            self.destinationmarker.map = self.googleMapsView
            
        }
    }
   
/////////////////////////////////////////
    func ordermenu(){

        UIView.animate(withDuration: 0.3, animations: {
            self.OrderButtomConstrain.constant = 0
            self.view.layoutIfNeeded()
            
        })    }
    
    @IBOutlet var OrderText: UITextField!
    //next
    @IBAction func Addordertocaret(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.OrderButtomConstrain.constant = 200
            self.view.layoutIfNeeded()
            self.orderButtomConst.constant = 0

        })
        
    }
////////////////////////////
    func featchDriver(destination:CLLocation) {
        Api.avilableDriver{(error:Error?, data:[driverModel]?) in
            var distancearray = [String:Double]()
            var strarr = [String]()
            for result in data!{
          let driverlocation = CLLocation(latitude: result.user_google_lat, longitude: result.user_google_long)
                let dist = destination.distance(from: driverlocation)
                distancearray = [result.driver_id:dist]
                let nearstDriver = distancearray.keysSortedByValue(isOrderedBefore: >)
                
               for dsa in nearstDriver{
                   strarr.append(dsa)
                }
                

            }
            self.driverArr = strarr

            
        }
    }
    
    
    
    
    @IBAction func sendOrderToDriver(_ sender: UIButton) {

        Api.requestOrderTodriver(clientlocation: clientLocation.text!, clientLat: location.latitude, clientLong: location.longitude, marketlocation: MarketLocation.text!, marketlat:  self.marketDestination.longitude, marketlong:  self.marketDestination.longitude, distance: distance.text!, orderdetailes: OrderText.text!, cost: WayCost.text!, drivers: driverArr) { (error:Error?, success:Bool) in
            

        }
        
        UIView.animate(withDuration: 0.05, animations: {
            self.orderButtomConst.constant = 300
            self.view.layoutIfNeeded()

        })
       // print(driverArr)
    }
    
}













/////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
extension HomeVC{
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
        self.view.insertSubview(orderFinalsend, aboveSubview: self.googleMapsView)
        /////add my location marker
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       // print(error)
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
       // print(error.localizedDescription)
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
        //print(resultsArray)
    }

    
    func calcDistance(distance:String,location:String,destnation:String) {
        
        let desbykilo = Int(distance)!/1000
        
        let parameters = [
            "my_distance":"\(desbykilo)"
        ]
        
        Alamofire.request(Config.DestanceCost, method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil).responseJSON{response in
            switch response.result
            {
            case.failure(let error):
                print(error)
            case.success(let value):
                let data = JSON(value).dictionaryObject
                self.distance.text = "\(distance) km"
                self.WayCost.text = data!["total_cost"]as? String
                self.MarketLocation.text = destnation
                self.clientLocation.text  =  location
            }
        }
        
    }
    
    //////slide menu
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
        if  Helper.isDriver() == false{
            self.performSegue(withIdentifier: "DriverSegue", sender: self)
        }
        
    }
    
    @IBAction func LogOut(_ sender: UIButton) {
        Helper.logout()
    }
    //    var urlstr = ""
    // var titlestr = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DriverSegue" {
            let destinationVC = segue.destination as! WebViewVC
            destinationVC.urlstr = Config.main
            destinationVC.titlestr = NSLocalizedString("Driver Registeration", comment: " driver registration")
        }
        
        
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
    
    /**
     action for search location by address
     
     - parameter sender: button search location
     */
    
    @IBAction func searchWithAddress(_ sender: AnyObject) {
        
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated:true, completion: nil)
    }
    
    @IBAction func Cancelorder(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.OrderButtomConstrain.constant = 200
            self.view.layoutIfNeeded()
            
        })
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
                    self.calcDistance(distance:data["distance"]["value"].stringValue, location: data["start_address"].stringValue, destnation: data["end_address"].stringValue )
                   // self.duration = data["duration"]["text"].stringValue
                }
                
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                self.polyline.path = path
                self.polyline.strokeWidth = 4
                self.polyline.strokeColor = UIColor.red
                self.polyline.map = self.googleMapsView
                
            }
            self.ordermenu()
            self.featchDriver(destination: endLocation)
        }
    }
}















