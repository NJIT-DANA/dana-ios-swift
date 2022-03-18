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
        architectsTableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: .reloadArchitects, object: nil)
       
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        self.setUI()
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.architectEntity){
            self.architectArrayfromDB = architectViewModel.fetchallArchitectsfromDB()
        }else{
            if danaHelper.checkNetworkConnection(){
                
                let indicatorView = danaHelper.activityIndicator(style: .large,
                                                                         center: self.view.center)
                indicatorView.style = UIActivityIndicatorView.Style.large
                indicatorView.color = .red
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
                //delay and call
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    self.architectsTableView.reloadData()
                }
            }
            else{
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
    }
    @IBAction func hamburgerAction(_ sender: Any) {
        HamburgerMenu().triggerSideMenu()
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
        cell.selectionStyle = .none
        cell.titleLabel.text = architect.title
        if let subject = architect.subject{
            cell.subLabel.text = subject.capitalized
        }
        else{
            cell.subLabel.text = architect.occupation?.capitalized
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"DetailsVC" ) as! DetailViewController
            nextViewController.architect = architectArrayfromDB[indexPath.row]
            nextViewController.type = textConstants.architectViewTitle
            self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
extension ArchitectsFirmsViewController{
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
extension Notification.Name {
     static let reloadArchitects = Notification.Name("reload")
}
extension ArchitectsFirmsViewController{
    @objc func hideHamburger(){
        HamburgerMenu().closeSideMenu()
    }
}
