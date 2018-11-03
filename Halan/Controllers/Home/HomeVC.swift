import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Font_Awesome_Swift
import SwiftyJSON
import Alamofire
import GooglePlacesSearchController
class HomeVC: UIViewController , UISearchBarDelegate ,GMSAutocompleteFetcherDelegate ,GMSMapViewDelegate,CLLocationManagerDelegate{
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
   // var searchResultController: SearchResultsController!
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
    @IBOutlet var OrderText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.menuButton.applyNavBarConstraints(size: (width: 33, height: 33))

        if Helper.isguest() == false {
            let userdata =  Helper.getdata()
            let urlString = Config.uploads+userdata["user_photo"]!
            let url = URL(string: urlString )
            ProfileImage.downloadedFrom(url: url!)
            ProfileName.setTitle(userdata["user_name"], for: .normal)

        }
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
   //////////////
    let GoogleMapsAPIServerKey = "AIzaSyArjmbYWTWZhDFFtPOLRLKYwjtBDkOEGrY"//AIzaSyBaqoHePcUxmopcU75X50VBBCAfrWo4nVc
    var controller: GooglePlacesSearchController!
    lazy var placesSearchController: GooglePlacesSearchController = {
        let controller = GooglePlacesSearchController(delegate: self as GooglePlacesAutocompleteViewControllerDelegate,
                                                      apiKey: GoogleMapsAPIServerKey,
                                                      placeType: .establishment,
                                                    coordinate: CLLocationCoordinate2D(latitude: self.location.latitude, longitude: self.location.longitude),
            radius: 10,
            strictBounds: true,
            searchBarPlaceholder: "Start typing..."
        )
        controller.searchBar.isTranslucent = false
       // controller.searchBar.barStyle = .black
        controller.searchBar.tintColor = .white
        controller.searchBar.barTintColor = .green
        return controller
    }()
    @IBAction func searchAddress(_ sender: UIBarButtonItem) {
        present(placesSearchController, animated: true, completion: nil)
    }
  
    }

////////////////////////////
extension HomeVC: GooglePlacesAutocompleteViewControllerDelegate {
    func viewController(didAutocompleteWith place: PlaceDetails) {
       // print(" late is \(String(describing: place.coordinate?.latitude ))")
        placesSearchController.isActive = false
        let lat = place.coordinate?.latitude
        let lon = place.coordinate?.longitude

        let position = CLLocationCoordinate2DMake(lat!, lon!)
        // self.googleMapsView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lon!, zoom: 15)
        self.destinationmarker.position = position
        self.destinationmarker.title = title
        self.destinationmarker.icon =    UIImage.init(icon:.FAMapMarker, size: CGSize(width: 75, height: 120), textColor: .red)
        let startlocation = CLLocation(latitude:self.location.latitude , longitude:self.location.longitude )
        let destination = CLLocation(latitude:lat! , longitude:lon!)
        self.marketDestination.longitude = lon!
        self.marketDestination.latitude = lat!
        self.drawPath(startLocation: startlocation, endLocation: destination)
        self.googleMapsView.animate(to: camera)
        self.destinationmarker.map = self.googleMapsView

        
        
        
        
        
        
        
        
    }
}

extension HomeVC{
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
        //searchResultController = SearchResultsController()
       // searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
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
       // self.searchResultController.reloadDataWithArray(self.resultsArray)
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
    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if resultsArray.count > 0{
//            resultsArray.removeAll()
//        }
//        gmsFetcher?.sourceTextHasChanged(searchText)
//        
//    }
    
    /**
     action for search location by address
     
     - parameter sender: button search location
     */
   // @IBAction func searchWithAddress(_ sender: AnyObject) {
//        let searchController = UISearchController(searchResultsController: searchResultController)
//        searchController.searchBar.delegate = self
//        self.present(searchController, animated:true, completion: nil)
   // }
    

    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        //let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
         let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&sensor=true&mode=driving&key=AIzaSyArjmbYWTWZhDFFtPOLRLKYwjtBDkOEGrY")!
        Alamofire.request(url).responseJSON { response in
            let json = try? JSON(data: response.data!)
            print(json as Any)
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


extension UIView {
    func applyNavBarConstraints(size: (width: CGFloat, height: CGFloat)) {
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: size.width)
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: size.height)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
}

// Usage
//button.applyNavBarConstraints(size: (width: 33, height: 33))













