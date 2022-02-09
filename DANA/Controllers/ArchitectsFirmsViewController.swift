//
//  ArchitectsFirmsViewController.swift
//  DANA
//
//  Created by Littman Library on 2/8/22.
//

import UIKit
import Alamofire
import AlamofireImage


class ArchitectsFirmsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let currentNetworkmanager = networkManager()
    var architectViewModel = ArchitectsViewModel()
    var architectArrayfromDB = [Architects_Firms]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        self.setUI()
        if !architectViewModel.checkArchitectsisEmpty(entity: textConstants.architectEntity){
            self.architectArrayfromDB = architectViewModel.fetchallArchitectsfromDB()
        }
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
        let cell:DANACustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: textConstants.architectcell, for: indexPath) as! DANACustomTableViewCell
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
