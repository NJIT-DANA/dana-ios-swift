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
        publicartTableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: .reloadArt, object: nil)

        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        self.setUI()
        if !danaHelper.checkifEntityisEmpty(entity: textConstants.artEntity){
            self.ArrayfromDB = publicartViewModel.fetchallPublicArtsfromDB()
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
                self.fetchArtsfromAPI {
                    DispatchQueue.main.async {
                        indicatorView.stopAnimating()
                        self.ArrayfromDB = self.publicartViewModel.fetchallPublicArtsfromDB()
                        self.publicartTableView.reloadData()
                    }
                    self.fetchImagesofArts {
                    }
                }
                //delay and call
                DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                    self.publicartTableView.reloadData()
                }
            }
            else{
                self.danaNetworkAlert()
            }
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
     
    }
    @IBAction func hamburgerAction(_ sender: Any){
    HamburgerMenu().triggerSideMenu()
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
        cell.selectionStyle = .none
        cell.titleLabel.text = art.name
        if let subject = art.subject{
            cell.subLabel.text = subject.capitalized
        }else{
            cell.subLabel.text = textConstants.publicartTitle.capitalized
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"DetailsVC" ) as! DetailViewController
            nextViewController.publicart = ArrayfromDB[indexPath.row]
            nextViewController.type = textConstants.publicartTitle
            self.navigationController?.pushViewController(nextViewController, animated: true)
    }
 
}
extension Notification.Name {
     static let reloadArt = Notification.Name("reload")
}
extension PublicArtViewController{
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
extension PublicArtViewController{
    @objc func hideHamburger(){
        HamburgerMenu().closeSideMenu()
    }
}
