//
//  PublicSpacesViewController.swift
//  DANA
//
//  Created by Littman Library on 2/12/22.
//

import UIKit
import Alamofire
import AlamofireImage

class PublicSpacesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var publicspaceViewModel = PublicSpaceViewModel()
    var ArrayfromDB = [PublicSpaces]()
    
    @IBOutlet weak var publicspaceTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: .reloadSpaces, object: nil)

        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        self.setUI()
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.spaceEntity){
            self.ArrayfromDB = publicspaceViewModel.fetchallPublicSpacesfromDB()
        }else{
            let indicatorView = danaHelper.activityIndicator(style: .large,
                                                                     center: self.view.center)
                    DispatchQueue.main.async {
                        self.view.addSubview(indicatorView)
                        indicatorView.startAnimating()
                    }
            self.fetchSpacesfromAPI {
                DispatchQueue.main.async {
                    indicatorView.stopAnimating()
                    self.ArrayfromDB = self.publicspaceViewModel.fetchallPublicSpacesfromDB()
                    self.publicspaceTableView.reloadData()
                }
                self.fetchImagesofSpaces {
                    print("cooooolll")
                }
            }
        }
        //delay and call
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.publicspaceTableView.reloadData()
        }
    }
    
    func fetchSpacesfromAPI(completionHandler: @escaping () -> (Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        publicspaceViewModel.makeFetchpublicSpacesApiCall(context: context) {
            print("finally everythings done for public spaces")
            completionHandler()
        }
        
    }
    func fetchImagesofSpaces(completionHandler: @escaping () -> (Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        publicspaceViewModel.makeFetchimagesApiCall(context: context) {
            print("finally everythings done for space images")
            completionHandler()
        }
        
    }
    
    func setUI() {
        self.navigationItem.title = textConstants.publicspaceTitle
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
    }
    @objc func reloadData(notification: NSNotification){
        self.publicspaceTableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayfromDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DANACustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: textConstants.publicspaceCell, for: indexPath) as! DANACustomTableViewCell
        let space = ArrayfromDB[indexPath.row] as PublicSpaces
        cell.pictureView.image = UIImage(named: textConstants.placeholderImage)
        if let url = space.imageUrl{
            let imageUrl = URL(string: url)
            cell.pictureView.af.setImage(withURL: imageUrl!)
        }
        cell.titleLabel.text = space.name
        return cell
    }
    
 
}
extension Notification.Name {
     static let reloadSpaces = Notification.Name("reload")
}
