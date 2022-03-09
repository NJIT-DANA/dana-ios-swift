//
//  PublicArtViewController.swift
//  DANA
//
//  Created by Littman Library on 2/22/22.
//

import UIKit
import Alamofire
import CoreData
import AlamofireImage

class PublicArtViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var publicartViewModel = PublicArtViewModel()
    var ArrayfromDB = [PublicArts]()

    @IBOutlet weak var publicartTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: .reloadArt, object: nil)

        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        self.setUI()
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.artEntity){
            self.ArrayfromDB = publicartViewModel.fetchallPublicArtsfromDB()
        }else{
            let indicatorView = danaHelper.activityIndicator(style: .large,
                                                                     center: self.view.center)
                    DispatchQueue.main.async {
                        self.view.addSubview(indicatorView)
                        indicatorView.startAnimating()
                    }
            self.fetchArtsfromAPI {
                DispatchQueue.main.async {
                    indicatorView.stopAnimating()
                    self.ArrayfromDB = self.publicartViewModel.fetchallPublicArtsfromDB()
                    self.publicartTableView.reloadData()
                }
                self.fetchImagesofArts {
                }
            }
        }
        //delay and call
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
            self.publicartTableView.reloadData()
        }
    }
    
    func fetchArtsfromAPI(completionHandler: @escaping () -> (Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        publicartViewModel.makeFetchpublicArtsApiCall(context: context) {
            print("finally everythings done for public spaces")
            completionHandler()
        }
        
    }
    func fetchImagesofArts(completionHandler: @escaping () -> (Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        publicartViewModel.makeFetchimagesApiCall(context: context) {
            print("finally everythings done for space images")
            completionHandler()
        }
        
    }
    @objc func reloadData(notification: NSNotification){
        self.publicartTableView.reloadData()
    }
    func setUI() {
        self.navigationItem.title = textConstants.publicartTitle
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayfromDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DANACustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: textConstants.publicartCell, for: indexPath) as! DANACustomTableViewCell
        let art = ArrayfromDB[indexPath.row] as PublicArts
        cell.pictureView.image = UIImage(named: textConstants.placeholderImage)
        cell.pictureView.backgroundColor = UIColor.white
        if let url = art.imageUrl{
            let imageUrl = URL(string: url)
            cell.pictureView.af.setImage(withURL: imageUrl!)
        }
        cell.titleLabel.text = art.name
        return cell
    }
    
 
}
extension Notification.Name {
     static let reloadArt = Notification.Name("reload")
}
