//
//  GMSMapViewController.swift
//  DANA
//
//  Created by Littman Library on 2/23/22.
//

import UIKit
import GoogleMaps
import MapKit
import Alamofire

class GMSMapViewController: UIViewController,GMSMapViewDelegate {
    let locationManager = CLLocationManager()
    var currentLocationStr = "Current location"
    let currentNetworkmanager = networkManager()
    var locnViewModel = GeoLocationViewModel()
    var locnArrayfromDB = [GeoLocations]()

    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.locationEntity){
            self.locnArrayfromDB = locnViewModel.fetchallLocationsfromDB()
        }
        self.addAnnotations()
          locationManager.delegate = self
          mapView.delegate = self
          if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
          } else {
            locationManager.requestWhenInUseAuthorization()
          }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addAnnotations()
    }
    func setUI() {
        self.navigationItem.title = textConstants.mapViewTitle
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
    }
    
    func addAnnotations(){
        
        
        for maplocationitem in locnArrayfromDB{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: maplocationitem.latitude, longitude: maplocationitem.longitude)
            marker.map = mapView
            marker.title = maplocationitem.title
}
}
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
         print("tapped")
            //create two dummy locations
            let source = CLLocationCoordinate2D.init(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
            let destination = CLLocationCoordinate2D.init(latitude: marker.position.latitude, longitude: marker.position.longitude)
           self.showRouteOnMap(pickupCoordinate: source, destinationCoordinate: destination)
            self.drawPath(sourcelat: (locationManager.location?.coordinate.latitude)!, sourcelong: (locationManager.location?.coordinate.longitude)!, destlat: marker.position.latitude, destlong:marker.position.longitude)
         return true
        }
        
    
    
    
    func drawPath(sourcelat:Double,sourcelong:Double,destlat:Double,destlong:Double)
    {
        let origin = "\(sourcelat),\(sourcelong)!"
        let destination = "\(destlat),\(destlong)"


        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(textConstants.googleAPIKey)"
        let request = AF.request(url)
        request.responseDecodable(of: [BuildingModel].self) { (response) in
        guard let buildings = response.value else { return }
        print(buildings)
        }
       
//          let json = JSON(data: response.data!)
//          let routes = json["routes"].arrayValue

//          for route in routes
//          {
//            let routeOverviewPolyline = route["overview_polyline"].dictionary
//            let points = routeOverviewPolyline?["points"]?.stringValue
//            let path = GMSPath.init(fromEncodedPath: points!)
//            let polyline = GMSPolyline.init(path: path)
//            polyline.map = self.mapView
//          }
        }
      
    
    
    
    
    
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile

            let directions = MKDirections(request: request)

            directions.calculate {[unowned self]response, error in
                guard let unwrappedResponse = response else { return }

                //for getting just one route
//                if let route = unwrappedResponse.routes.first {
//                    //show on map
//
//                    self.mapView.addOverlay(route.polyline)
//                    //set the map area to show the route
//                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
//                }

                //if you want to show multiple routes then you can get all routes in a loop in the following statement
                //for route in unwrappedResponse.routes {}
            }
        }

}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
// MARK: - CLLocationManagerDelegate
//1
extension GMSMapViewController: CLLocationManagerDelegate {
  // 2
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    // 3
    guard status == .authorizedWhenInUse else {
      return
    }
    // 4
    locationManager.requestLocation()

    //5
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }

  // 6
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }

    // 7
    mapView.camera = GMSCameraPosition(
      target: location.coordinate,
      zoom: 15,
      bearing: 0,
      viewingAngle: 0)
  }

  // 8
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print(error)
  }
    
}
