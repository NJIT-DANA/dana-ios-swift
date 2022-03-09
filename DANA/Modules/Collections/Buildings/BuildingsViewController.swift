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
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        
        self.setUI()
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.buildingEntity){
            self.buildingArrayfromDB = buildingViewModel.fetchallBuildingsfromDB()
        }else{
            let indicatorView = danaHelper.activityIndicator(style: .large,
                                                                     center: self.view.center)
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
        }
        
        //delay and call
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.buildingTableView.reloadData()
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
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
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
        return cell
    }
    
 
}
