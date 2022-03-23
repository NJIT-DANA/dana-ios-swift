//
//  CollectionViewController.swift
//  DANA
//
//  Created by Littman Library on 2/6/22.
//

import UIKit
import CoreData

class CollectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var collectionTableView: UITableView!
    
    let collectionArray = [textConstants.architectViewTitle,textConstants.publicspaceTitle,textConstants.buildingsTitle,textConstants.publicartTitle]
    let imageArray = [textConstants.architectsImage,textConstants.buildingsImage,textConstants.publicspacesImage,textConstants.publicartImage]
    
    let currentNetworkmanager = networkManager()
    var architectViewModel = ArchitectsViewModel()
    var locnViewModel = GeoLocationViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //remove comments later when running on real device
        collectionTableView.separatorStyle = .none
    
      
        self.setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(setUI), name: Notification.Name("ModeSwiched"), object: nil)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setUI()
    }
    
    @objc func setUI() {
  
     
        if (self.traitCollection.userInterfaceStyle == .dark) {
            self.navigationItem.title = textConstants.collectionTitle
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
            self.navigationItem.title = textConstants.collectionTitle
            guard let customFonttitle = UIFont(name: "HelveticaNeue-Bold", size: 28) else {
                       fatalError("error"
                       )
                   }
            self.navigationController?.navigationBar.titleTextAttributes =  [
                .foregroundColor: UIColor.black,
                .font: customFonttitle
            ]
        }
        
       
      //  self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    
    @objc func showsettings(){
        
    }
    
    @IBAction func hamburgerBtnAction(_ sender: Any) {
        HamburgerMenu().triggerSideMenu()
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
    
    
    //MARK:- architect Methods
    
    func fetchArchitectsfromAPI(completionHandler: @escaping () -> (Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        architectViewModel.makeFetchArchitectsApiCall(context: context) {
            print("finally everythings done for architects")
            completionHandler()
        }
        
    }
    
    func fetchImagesofArchitects(completionHandler: @escaping () -> (Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        architectViewModel.makeFetchimagesApiCall(context: context) {
            print("finally everythings done for architects images")
            completionHandler()
        }
        
    }
    
//    //MARK:- Map Methods
//    func fetchmapsfromAPI(completionHandler: @escaping () -> (Void)){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        locnViewModel.makeFetchLocationsApiCall(context: context) {
//            print("finally everythings done for maps")
//            completionHandler()
//        }
//
//    }
//    func fetchDetailsofLocations(completionHandler: @escaping () -> (Void)) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        locnViewModel.makeFetchDetailsApiCall(context: context) {
//            print("finally everythings done for maps details")
//            completionHandler()
//        }
       
    }
    
    
    

extension CollectionViewController{
        func deleteAllData(entity: String)
        {   let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
            do { try context.execute(DelAllReqVar) }
            catch { print(error) }
        }
}

//extension CollectionViewController{
//    func fetchDatafromAPI(){
//
//        let indicatorView = danaHelper.activityIndicator(style: .large,
//                                                                 center: self.view.center)
//                DispatchQueue.main.async {
//                    self.view.addSubview(indicatorView)
//                    indicatorView.startAnimating()
//                }
//        let queue = OperationQueue()
//
//
//        let operation2 = BlockOperation {
//            self.fetchImagesofArchitects {
//
//            }
//        }
//        let operation3 = BlockOperation {
//            self.fetchDetailsofLocations {
//                DispatchQueue.main.async {
//                        indicatorView.stopAnimating()
//                   }
//            }
//        }
//
//
//        let operation1 = BlockOperation {
//            self.fetchArchitectsfromAPI {
//                queue.addOperation(operation2)
//            }
//        }
//
//        let operation0 = BlockOperation {
//            self.fetchmapsfromAPI {
//                queue.addOperation(operation3)
//            }
//        }
//        operation1.completionBlock = {
//            print("op1 finished")
//
//
//        }
//
//        operation2.addDependency(operation1)
//        operation3.addDependency(operation0)
//       // completionOperation.addDependency(operation3)
//
//        print("Adding operations")
//        queue.addOperations([operation1,operation0], waitUntilFinished: true)
//
//
//        print("Done!")
//    }
//
//
//
//
//    func getAllDataFromAPIUsingDispactGroup(){
//
//        let indicatorView = danaHelper.activityIndicator(style: .large,
//                                                         center: self.view.center)
//        DispatchQueue.main.async {
//            self.view.addSubview(indicatorView)
//            indicatorView.startAnimating()
//        }
//        let dispatchGroup = DispatchGroup()
//
//            dispatchGroup.enter()
//            self.fetchArchitectsfromAPI {
//                    dispatchGroup.leave()
//
//            }
//
//
//            dispatchGroup.enter()
//            self.fetchmapsfromAPI {
//                dispatchGroup.leave()
//            }
//
//            dispatchGroup.enter()
//            self.fetchImagesofArchitects {
//                dispatchGroup.leave()
//            }
//
//            dispatchGroup.enter()
//            self.fetchDetailsofLocations {
//                dispatchGroup.leave()
//            }
//
//         dispatchGroup.notify(queue: DispatchQueue.main){
//            DispatchQueue.main.async {
//                indicatorView.stopAnimating()
//            }
//        }
//    }
////    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Car")
////    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
////
////    do {
////        try myPersistentStoreCoordinator.execute(deleteRequest, with: myContext)
////    } catch let error as NSError {
////        // TODO: handle the error
////    }
//}
extension CollectionViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DANAHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: textConstants.homeCell, for: indexPath) as! DANAHomeTableViewCell
        cell.titlelabel.text = collectionArray[indexPath.row]
        cell.collectionimageView.image = UIImage(named:imageArray[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        switch indexPath.row{
        case 0:
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: collectionArray[indexPath.row]) as! ArchitectsFirmsViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        case 1:
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: collectionArray[indexPath.row]) as! PublicSpacesViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        case 2:
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: collectionArray[indexPath.row]) as! BuildingsViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        case 3:
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: collectionArray[indexPath.row]) as! PublicArtViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        default:
            print("default")
        }
    }
}
extension CollectionViewController{
     func danaNetworkAlert(){
        // Create new Alert
         let dialogMessage = UIAlertController(title: "No Internet Connection", message: textConstants.danaNetworkMessage, preferredStyle: .alert)
         let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             print("Ok button tapped")
          })
         dialogMessage.addAction(ok)
         self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
}
extension CollectionViewController{
    @objc func hideHamburger(){
        HamburgerMenu().closeSideMenu()
    }
    
    
}
