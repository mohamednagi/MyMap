import UIKit
import MapKit
import CoreData
import CoreLocation

class ViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate{
   
    @IBOutlet weak var LocationTF: UITextField!
    @IBOutlet weak var CommentTF: UITextField!
    @IBOutlet weak var MapKitView: MKMapView!
    var locationManager = CLLocationManager()
    var latitude:Double = 0
    var longtude:Double = 0
    
    var transmittedtitle = ""
    var transmittedsubtitle = ""
    var transmittedlat:Double=0
    var transmittedlon:Double=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapKitView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.choosingLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2
        self.MapKitView.addGestureRecognizer(gestureRecognizer)
      
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: transmittedlat, longitude: transmittedlon)
            annotation.coordinate = coordinate
            annotation.title = transmittedtitle
            annotation.subtitle = transmittedsubtitle
            self.MapKitView.addAnnotation(annotation)
            self.LocationTF.text = transmittedtitle
            self.CommentTF.text = transmittedsubtitle
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.MapKitView.setRegion(region, animated: true)
        
    }
    @objc func choosingLocation(gestureRecognizer : UILongPressGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began{
                let point = gestureRecognizer.location(in: self.MapKitView)
            let coordinate = self.MapKitView.convert(point, toCoordinateFrom: self.MapKitView)
            self.latitude = coordinate.latitude
            self.longtude = coordinate.longitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = LocationTF.text
            annotation.subtitle = CommentTF.text
            self.MapKitView.addAnnotation(annotation)
       
    }
    }
    
    @IBAction func SaveButton(_ sender: UIButton) {
        let Location = NSEntityDescription.insertNewObject(forEntityName:"Locations", into: Context)
        Location.setValue(LocationTF.text!, forKey: "title")
        Location.setValue(CommentTF.text!, forKey: "subtitle")
        Location.setValue(latitude, forKey: "lat")
        Location.setValue(longtude, forKey: "lon")
        
        do {
            try Context.save()
            print("Saved")
        } catch  {
            print("Error")
        }
    }
}
