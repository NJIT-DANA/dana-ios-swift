//
//  MapViewController.swift
//  mapTrial
//
//  Created by Rini Joseph on 1/16/22.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    
    
    
    
    
    @IBOutlet weak var locationMapView: MKMapView!
    
    //var maplocations : [MapLocation] = []
    var locationManager:CLLocationManager!
    var currentLocationStr = "Current location"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fetchmaplocationsfromDB()
        locationMapView.delegate = self
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            locationMapView.setRegion(viewRegion, animated: false)
        }
        self.locationManager = locationManager
        
        DispatchQueue.main.async {
            // self.locationManager.startUpdatingLocation()
            //this function will always keep on updating the user location
            
        }
    }
  
    //MARK:- CLLocationManagerDelegate Methods
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        
    }
    
    
    func fetchmaplocationsfromDB(){
        //uncomment later
        // maplocations = fetchallMaplocations();
        addAnnotations()
        
    }
    
    
    
    
    func addAnnotations(){
        //uncomment later
        //        for maplocationitem in maplocations{
        //            let CLLCoordType = CLLocationCoordinate2D(latitude: maplocationitem.latitude,longitude: maplocationitem.longitude);
        //            let anno = MKPointAnnotation();
        //            anno.coordinate = CLLCoordType;
        //            anno.title = maplocationitem.address;
        //            anno.subtitle = maplocationitem.url;
        //            myMap.addAnnotation(anno);
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        locationMapView.setRegion(mRegion, animated: true)
        
        // Get user's Current Location and Drop a pin
        //        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        //            mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
        //            mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
        //            myMap.addAnnotation(mkAnnotation)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    //MARK:- Intance Methods
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK:- Intance Methods
    
    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)
        
        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            
            if let mPlacemark = placemarks{
                if let dict = mPlacemark[0].addressDictionary as? [String: Any]{
                    if let Name = dict["Name"] as? String{
                        if let City = dict["City"] as? String{
                            self.currentLocationStr = Name + ", " + City
                        }
                    }
                }
            }
        }
        return currentLocationStr
    }
    
    //fetch
    //    func fetchallMaplocations()-> Array<MapLocation>{
    //
    //        //let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    //              let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //              let context = appDelegate.persistentContainer.viewContext
    //
    //                let categoriesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MapLocation")
    //
    //                do {
    //                    let categoriesFetch = try context.fetch(categoriesFetch) as! [MapLocation]
    //                    print(categoriesFetch.count)
    //                    print(categoriesFetch[0])
    //                    return categoriesFetch
    //                } catch {
    //                    fatalError("Failed to fetch categories: \(error)")
    //                }
    //
    //
    //    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    
    
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        //uncomment later
        
        //        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "popover") as! AnnotationViewController
        //        vc.modalPresentationStyle = .popover
        //        vc.titletext = view.annotation?.title ?? "defaultval"
        //        print(view.annotation?.subtitle)
        //           // let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        //        //popover.barButtonItem = view.self
        //            present(vc, animated: true, completion:nil)
        
        
    }
}

//{
//
//   print("didSelectAnnotationTapped")
//
//
//   // Configure the presentation controller
//    let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier:"popover") as? AnnotationViewController
//    popoverContentController?.modalPresentationStyle = .popover
//
//
//
//    if let popoverPresentationController = popoverContentController?.popoverPresentationController {
//    popoverPresentationController.permittedArrowDirections = .up
//    popoverPresentationController.sourceView = view
//        popoverPresentationController.sourceRect = view.frame
//    popoverPresentationController.delegate = self
//    if let popoverController = popoverContentController {
//    present(popoverController, animated: true, completion: nil)
//
//
//
//
//
//    }
//    }
//
//}
