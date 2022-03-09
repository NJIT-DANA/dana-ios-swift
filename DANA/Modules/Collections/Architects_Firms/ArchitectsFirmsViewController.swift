//
//  ArchitectsFirmsViewController.swift
//  DANA
//
//  Created by Littman Library on 2/8/22.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData


class ArchitectsFirmsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let currentNetworkmanager = networkManager()
    var architectViewModel = ArchitectsViewModel()
    var architectArrayfromDB = [Architects_Firms]()
    
    @IBOutlet weak var architectsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: .reloadArchitects, object: nil)
     
      //  NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
       
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        self.setUI()
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.architectEntity){
            self.architectArrayfromDB = architectViewModel.fetchallArchitectsfromDB()
        }else{
            
                let indicatorView = danaHelper.activityIndicator(style: .large,
                                                                         center: self.view.center)
                        DispatchQueue.main.async {
                            self.view.addSubview(indicatorView)
                            indicatorView.startAnimating()
                        }
                self.fetchArchitectsfromAPI {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                        self.architectArrayfromDB = self.architectViewModel.fetchallArchitectsfromDB()
                        self.architectsTableView.reloadData()
                    }
                    self.fetchImagesofArchitects {
                        print("cooooolll")
                    }
                }
            }
        //delay and call
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.architectsTableView.reloadData()
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
    
    @objc func reloadData(notification: NSNotification){
        self.architectsTableView.reloadData()
    }
    func setUI() {
        self.navigationItem.title = textConstants.architectViewTitle
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return architectArrayfromDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DANACustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: textConstants.architectCell, for: indexPath) as! DANACustomTableViewCell
        let architect = architectArrayfromDB[indexPath.row] as Architects_Firms
        cell.pictureView.image = UIImage(named: textConstants.placeholderImage)
        if let url = architect.imageUrl{
            let imageUrl = URL(string: url)
            cell.pictureView.af.setImage(withURL: imageUrl!)
            //             cell.pictureView.af_setImage(withURL: imageUrl!, cacheKey: "", placeholderImage: .none, serializer: .none, filter: .none, progress: .none, progressQueue: .global(), imageTransition: .noTransition, runImageTransitionIfCached: false) {  (response) -> Void in
            //                 print("image: \(cell.pictureView.image)")
        }
        cell.titleLabel.text = architect.name
        return cell
    }
}
extension Notification.Name {
     static let reloadArchitects = Notification.Name("reload")
}

