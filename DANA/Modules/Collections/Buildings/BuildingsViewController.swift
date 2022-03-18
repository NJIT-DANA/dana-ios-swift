//
//  BuildingsViewController.swift
//  DANA
//
//  Created by Littman Library on 2/8/22.
//

import UIKit
import Alamofire
import AlamofireImage


class BuildingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let currentNetworkmanager = networkManager()
    var buildingViewModel = BuildingsViewModel()
    var buildingArrayfromDB = [Buildings]()
    @IBOutlet weak var buildingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildingTableView.separatorStyle = .none
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        
        self.setUI()
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.buildingEntity){
            self.buildingArrayfromDB = buildingViewModel.fetchallBuildingsfromDB()
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
                self.fetchBuildingsfromAPI {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                        self.buildingArrayfromDB = self.buildingViewModel.fetchallBuildingsfromDB()
                        self.buildingTableView.reloadData()
                    }
                    self.fetchImagesofSpaces {
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    self.buildingTableView.reloadData()
                }
            }
            else{
                self.danaNetworkAlert()
            }
            //delay and call
            
            }
            
    }
    
    func fetchBuildingsfromAPI(completionHandler: @escaping () -> (Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        buildingViewModel.makeFetchBuildingsApiCall(context: context) {
            print("finally everythings done for building items")
            completionHandler()
        }
        
    }
    func fetchImagesofSpaces(completionHandler: @escaping () -> (Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        buildingViewModel.makeFetchimagesApiCall(context: context) {
            print("finally everythings done for building images")
            completionHandler()
        }
        
    }
    
    
    
    func setUI() {
        self.navigationItem.title = textConstants.buildingsTitle
       
    }
    @IBAction func hamburgerAction(_ sender: Any) {
        HamburgerMenu().triggerSideMenu()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildingArrayfromDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:DANACustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: textConstants.buildingCell, for: indexPath) as! DANACustomTableViewCell
        let building = buildingArrayfromDB[indexPath.row] as Buildings
        cell.pictureView.image = UIImage(named: textConstants.placeholderImage)
        if let url = building.imageUrl{
            let imageUrl = URL(string: url)
            cell.pictureView.af.setImage(withURL: imageUrl!)
        }
        cell.titleLabel.text = building.name
        if let subject = building.subject {
            cell.subLabel.text = subject.capitalized
        }else{
            cell.subLabel.text = "Building"
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"DetailsVC" ) as! DetailViewController
            nextViewController.building = buildingArrayfromDB[indexPath.row]
            nextViewController.type = textConstants.buildingsTitle
            self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
 
}
extension BuildingsViewController{
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
extension BuildingsViewController{
    @objc func hideHamburger(){
        HamburgerMenu().closeSideMenu()
    }
}
