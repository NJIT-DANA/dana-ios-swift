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
import CoreData

class GMSMapViewController: UIViewController,GMSMapViewDelegate, MapMarkerDelegate {
    func didTapInfoButton(data: NSDictionary) {
        
    }
    let blackTransparentViewTag = 022981994
    let locationManager = CLLocationManager()
    let currentNetworkmanager = networkManager()
    var locnViewModel = GeoLocationViewModel()
    var hiddenListView = true
    var tappedMarker = GMSMarker()
    var tappedLocation = GeoLocations()
    var locnArrayfromDB = [GeoLocations]()
    private var infoWindow = mapMarkerWindowView()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    
    @IBOutlet weak var listIcon: UIButton!
    @IBOutlet weak var mapbaseView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.hiddenListView = true
        self.listView.isHidden = true
        
        let blackTransparentView = self.addBlackTransparentView()
       // blackTransparentView.alpha = 0.2
        self.mapView.addSubview(blackTransparentView)
        
        listTableView.separatorStyle = .none
        let indicatorView = danaHelper.activityIndicator(style: .large,
                                                         center: self.view.center)
        indicatorView.style = UIActivityIndicatorView.Style.large
        indicatorView.color = .red
        DispatchQueue.main.async {
            self.view.addSubview(indicatorView)
            indicatorView.startAnimating()
        }
        
        if danaHelper.checkifEntityisEmpty(entity: textConstants.locationEntity){
            self.fetchmapsfromAPI {
                self.fetchDetailsofLocations {
                    DispatchQueue.main.async {
                        
                        
                    }
                }
            }
        }
        
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.locationEntity){
            self.locnArrayfromDB = locnViewModel.fetchallLocationsfromDB()
           
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [self] in
            self.locnArrayfromDB = self.locnViewModel.fetchallLocationsfromDB()
            blackTransparentView.removeFromSuperview()
            indicatorView.stopAnimating()
            self.addAnnotations()
        }
        
        locationManager.delegate = self
        mapView.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNavigationstyle), name: Notification.Name("ModeSwiched"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
     setNavigationstyle()
    }
    
    //MARK:- Map Methods
    func fetchmapsfromAPI(completionHandler: @escaping () -> (Void)){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        locnViewModel.makeFetchLocationsApiCall(context: context) {
            print("finally everythings done for maps")
            completionHandler()
        }
        
    }
    func fetchDetailsofLocations(completionHandler: @escaping () -> (Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        locnViewModel.makeFetchDetailsApiCall(context: context) {
            print("finally everythings done for maps details")
            completionHandler()
            
        }
       
    }
    @objc func setNavigationstyle(){
        
            if (self.traitCollection.userInterfaceStyle == .dark) {
                self.navigationItem.title = textConstants.mapViewTitle
                guard let customFonttitle = UIFont(name: "HelveticaNeue-Bold", size: 28) else {
                           fatalError("error"
                           )
                       }
                self.navigationController?.navigationBar.titleTextAttributes =  [
                    .foregroundColor: UIColor.white,
                    .font: customFonttitle
                ]
            }
            else{
                self.navigationItem.title = textConstants.mapViewTitle
                guard let customFonttitle = UIFont(name: "HelveticaNeue-Bold", size: 28) else {
                           fatalError("error"
                           )
                       }
                self.navigationController?.navigationBar.titleTextAttributes =  [
                    .foregroundColor: UIColor.black,
                    .font: customFonttitle
                ]
            }
            
           
           // self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    func setUI() {
        
        if danaHelper.checkNetworkConnection(){
       //  self.resetDB()
        }
        
    }
    
    
    func addAnnotations(){
        for maplocationitem in locnArrayfromDB{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: maplocationitem.latitude, longitude: maplocationitem.longitude)
            marker.map = mapView
            marker.title = maplocationitem.title
            marker.userData = maplocationitem.id

}
}
        
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        print("tapped")
//
//        //create two dummy locations
//
//
//
//        let source = CLLocationCoordinate2D.init(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
//        let destination = CLLocationCoordinate2D.init(latitude: marker.position.latitude, longitude: marker.position.longitude)
//        self.showRouteOnMap(pickupCoordinate: source, destinationCoordinate: destination)
//        self.drawPath(sourcelat: (locationManager.location?.coordinate.latitude)!, sourcelong: (locationManager.location?.coordinate.longitude)!, destlat: marker.position.latitude, destlong:marker.position.longitude)
//        return true
//    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        locationMarker = marker
        infoWindow.removeFromSuperview()
        infoWindow = loadNiB()
        self.tappedMarker = marker
        infoWindow.delegate = self
        infoWindow.layer.shadowColor = UIColor.systemBlue.cgColor
        infoWindow.layer.shadowOpacity = 1
        infoWindow.layer.shadowOffset = .zero
        infoWindow.layer.shadowRadius = 10
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.thick.rawValue,NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 17.0)!] as [NSAttributedString.Key : Any]
        let attributedString = NSAttributedString(string: marker.title ?? "", attributes: titleAttribute)
        infoWindow.titleButton.setAttributedTitle(attributedString, for: .normal)
        infoWindow.titleButton.titleLabel?.isHidden = false
        infoWindow.titleButton.addTarget(self, action: #selector(showDetails(_:)), for: .touchUpInside)
        for item in locnArrayfromDB{
            if (item.id == marker.userData as! Int){
                infoWindow.descriptionLabel.text = item.address
                infoWindow.detailLabel.text = item.mapdescription
                tappedLocation = item
            }
        }
        self.mapView.addSubview(infoWindow)
        infoWindow.translatesAutoresizingMaskIntoConstraints = false
            let constraint_leading = NSLayoutConstraint(item: infoWindow, attribute: .leading, relatedBy: .equal, toItem: self.mapView, attribute: .leading, multiplier: 1, constant: 10)
            let constraint_top = NSLayoutConstraint(item: infoWindow, attribute: .top, relatedBy: .equal, toItem: self.mapView, attribute: .top, multiplier: 1, constant: 10)
            let constraint_height = NSLayoutConstraint(item: infoWindow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: infoWindow.frame.height)
            let constraint_width = NSLayoutConstraint(item: infoWindow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: infoWindow.frame.width)
            let constraint_center = NSLayoutConstraint(item: infoWindow, attribute: .centerX, relatedBy: .equal, toItem: self.mapView, attribute: .centerX, multiplier: 1, constant: 0)
            self.mapView.addConstraint(constraint_leading)
            self.mapView.addConstraint(constraint_top)
            infoWindow.addConstraint(constraint_height)
            infoWindow.addConstraint(constraint_width)
            self.mapView.addConstraint(constraint_center)

            //infoWindow.center.y += 80
        return false
    }
    //
    
    //empty the default infowindow
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    // take care of the close event
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
    @objc func showDetails(_ sender: UIButton!) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"DetailsVC" ) as! DetailViewController
            nextViewController.mapLoctn = tappedLocation
            nextViewController.type = textConstants.mapViewTitle
            self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.thick.rawValue,NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 17.0)!] as [NSAttributedString.Key : Any]
        let attributedString = NSAttributedString(string: tappedMarker.title ?? "", attributes: titleAttribute)

        infoWindow.titleButton.titleLabel?.attributedText = attributedString
        
    }
    
    
    
    
    
    @IBAction func showList(_ sender: Any) {
        self.hiddenListView = false
        self.mapbaseView.isHidden = true
        self.listView.isHidden = false
        self.listTableView.reloadData()
        
    }
    
    @IBAction func danashowMap(_ sender: Any) {
        self.hiddenListView = true
        self.mapbaseView.isHidden = false
        self.listView.isHidden = true
       
    }
    
    func loadNiB() -> mapMarkerWindowView {
        let infoWindow = mapMarkerWindowView.instanceFromNib() as! mapMarkerWindowView
        return infoWindow
    }
    
    
    @IBAction func hamburgerAction(_ sender: Any) {
        HamburgerMenu().triggerSideMenu()
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
    
    
    func zoom() {

        CATransaction.begin()
        CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)

        // It will animate your camera to the specified lat and long
        let camera = GMSCameraPosition.camera(withLatitude: tappedLocation.latitude, longitude: tappedLocation.longitude, zoom: 15)
        mapView!.animate(to: camera)

        CATransaction.commit()
    }
    
    
    
    func resetDB(){
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.artEntity){
            self.deleteAllData(entity: textConstants.artEntity)
        }
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.spaceEntity){
            self.deleteAllData(entity: textConstants.spaceEntity)
        }
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.architectEntity){
            self.deleteAllData(entity: textConstants.architectEntity)
        }
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.buildingEntity){
            self.deleteAllData(entity: textConstants.buildingEntity)
        }
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.locationEntity){
            self.deleteAllData(entity: textConstants.locationEntity)
        }
    }
    func danaNetworkAlert(){
       // Create new Alert
        let dialogMessage = UIAlertController(title: "No Internet Connection", message: textConstants.danaNetworkMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
   }
    func deleteAllData(entity: String)
    {   let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
    }
    
    
}
extension GMSMapViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tappedLocation = locnArrayfromDB[indexPath.row]
        infoWindow.removeFromSuperview()
        infoWindow = loadNiB()
        infoWindow.delegate = self
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.thick.rawValue,NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 17.0)!] as [NSAttributedString.Key : Any]
        let attributedString = NSAttributedString(string: tappedLocation.title ?? "", attributes: titleAttribute)
        infoWindow.titleButton.titleLabel?.isHidden = false
        infoWindow.titleButton.setAttributedTitle(attributedString, for: .normal)
        
        infoWindow.layer.shadowColor = UIColor.systemBlue.cgColor
        infoWindow.layer.shadowOpacity = 1
        infoWindow.layer.shadowOffset = .zero
        infoWindow.layer.shadowRadius = 10
        infoWindow.titleButton.addTarget(self, action: #selector(showDetails(_:)), for: .touchUpInside)
                infoWindow.descriptionLabel.text = tappedLocation.address
                infoWindow.detailLabel.text = tappedLocation.mapdescription
        self.mapView.addSubview(infoWindow)
        infoWindow.translatesAutoresizingMaskIntoConstraints = false
            let constraint_leading = NSLayoutConstraint(item: infoWindow, attribute: .leading, relatedBy: .equal, toItem: self.mapView, attribute: .leading, multiplier: 1, constant: 10)
            let constraint_top = NSLayoutConstraint(item: infoWindow, attribute: .top, relatedBy: .equal, toItem: self.mapView, attribute: .top, multiplier: 1, constant: 10)
            let constraint_height = NSLayoutConstraint(item: infoWindow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: infoWindow.frame.height)
            let constraint_width = NSLayoutConstraint(item: infoWindow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: infoWindow.frame.width)
            let constraint_center = NSLayoutConstraint(item: infoWindow, attribute: .centerX, relatedBy: .equal, toItem: self.mapView, attribute: .centerX, multiplier: 1, constant: 0)
            self.mapView.addConstraint(constraint_leading)
            self.mapView.addConstraint(constraint_top)
            infoWindow.addConstraint(constraint_height)
            infoWindow.addConstraint(constraint_width)
            self.mapView.addConstraint(constraint_center)
        self.zoom()
        self.hiddenListView = true
        self.mapbaseView.isHidden = false
        self.listView.isHidden = true

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DanaListTableViewCell = tableView.dequeueReusableCell(withIdentifier: textConstants.listCell, for: indexPath) as! DanaListTableViewCell
        cell.selectionStyle = .none
        cell.maptitleLabel.text = locnArrayfromDB[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        locnArrayfromDB.count
        
    }
}
extension GMSMapViewController{
    @objc func hideHamburger(){
        HamburgerMenu().closeSideMenu()
    }
    //MARK: - Shadow View
       func addBlackTransparentView() -> UIView{
           //Black Shadow on MainView(i.e on TabBarController) when side menu is opened.
           let blackView = self.mapView.viewWithTag(blackTransparentViewTag)
           if blackView != nil{
               return blackView!
           }else{
               let sView = UIView(frame: self.mapView.bounds)
               sView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
               sView.tag = blackTransparentViewTag
               sView.alpha = 0.5
               sView.backgroundColor = UIColor.white
               return sView
           }
       }
    
  

}
