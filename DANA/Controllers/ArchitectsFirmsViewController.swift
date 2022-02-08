//
//  ArchitectsFirmsViewController.swift
//  DANA
//
//  Created by Littman Library on 2/8/22.
//

import UIKit

class ArchitectsFirmsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let currentNetworkmanager = networkManager()
    var architectViewModel = ArchitectsViewModel()
    var architectArrayfromDB = [Architects_Firms]()
            override func viewDidLoad() {
                super.viewDidLoad()
                self.setUI()
                self.architectArrayfromDB = architectViewModel.fetchallArchitectsfromDB()
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
         let cell:DANACustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "architectcell", for: indexPath) as! DANACustomTableViewCell
         let architect = architectArrayfromDB[indexPath.row] as Architects_Firms
         cell.pictureView.image = UIImage(named: "placeholder")
         cell.titleLabel.text = architect.name
        

        return cell
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//            return "Section \(section)"
//        }
    
    
}
