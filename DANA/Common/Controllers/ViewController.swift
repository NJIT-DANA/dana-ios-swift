//
//  ViewController.swift
//  DANA
//
//  Created by Littman Library on 3/15/22.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tabbarContainerView: UIView!
    @IBOutlet weak var slideMenuView: UIView!
    
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    var hamburgerMenuIsVisible = false
    var initialPos: CGPoint?
    var touchPos: CGPoint?
    let blackTransparentViewTag = 02271994

   
    lazy var frontVC: UITabBarController? = {
        let front = self.storyboard?.instantiateViewController(withIdentifier: "FrontTabbar")
        return front as! UITabBarController?
    }()
    
//    lazy var rearVC: UIViewController? = {
//        let rear = self.storyboard?.instantiateViewController(withIdentifier: "rearVC")
//        return rear
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTabbar()
        tableView.separatorStyle = .none
       
       // addShadowToView()
        setUpNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("ModeSwiched"), object: nil)
        //setUpGestures()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = UIColor.green
    }
    @objc func reloadTableView() {
        self.tableView.reloadData()
    }
    func displayTabbar(){
        // To display Tabbar in TabbarContainerView
        if let vc = frontVC {
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            vc.view.frame = self.tabbarContainerView.bounds
            self.tabbarContainerView.addSubview(vc.view)
          
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SettingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: textConstants.menuCell, for: indexPath) as! SettingsTableViewCell
        cell.selectionStyle = .none
         switch indexPath.row{
        case 0:
           
            cell.settingsImage?.image = UIImage(named: "danafont")
            
            if self.traitCollection.userInterfaceStyle == .dark {
                cell.settingsImage?.image = UIImage(named: "danafontdarkmode")
            }
            cell.titleLabel.text = "Font Size"
            cell.descrtiptionLabel.text = "Allow you to change font size"
        case 1:
            cell.settingsImage?.image = UIImage(named: "danadarkmode")
            cell.descrtiptionLabel.text = "Allow you to switch to dark background"
            cell.titleLabel.text = "Dark Mode"
            if self.traitCollection.userInterfaceStyle == .dark {
                cell.settingsImage?.image = UIImage(named: "danalightmode")
                cell.descrtiptionLabel.text = "Allow you to switch to light background"
                cell.titleLabel.text = "Light Mode"
            }
         
            
        case 2:
            cell.settingsImage?.image = UIImage(named: "danaabout")
            if self.traitCollection.userInterfaceStyle == .dark {
                cell.settingsImage?.image = UIImage(named: "danaaboutdarkmode")
            }
            cell.titleLabel.text = "About"
            cell.descrtiptionLabel.text = "Read more about DANA"
        
        default:
            cell.settingsImage?.image = UIImage(named: "danadarkmode")
            cell.descrtiptionLabel.text = "Allow you to switch to dark background"
            cell.titleLabel.text = "Dark Mode"
            if self.traitCollection.userInterfaceStyle == .dark {
                cell.settingsImage?.image = UIImage(named: "danalightmode")
                cell.descrtiptionLabel.text = "Allow you to switch to light background"
                cell.titleLabel.text = "Light Mode"
            }
         
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        switch indexPath.row{
        case 1:
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            self.present(nextViewController, animated: true)
        case 2:

            
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
            self.present(nextViewController, animated: true)
            
            
            
//        case 1:
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: collectionArray[indexPath.row]) as! PublicSpacesViewController
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//        case 2:
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: collectionArray[indexPath.row]) as! BuildingsViewController
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//        case 3:
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: collectionArray[indexPath.row]) as! PublicArtViewController
//            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        default:
            print("default")
        }
    }

 //MARK: - Shadow View
    func addBlackTransparentView() -> UIView{
        //Black Shadow on MainView(i.e on TabBarController) when side menu is opened.
        let blackView = self.tabbarContainerView.viewWithTag(blackTransparentViewTag)
        if blackView != nil{
            return blackView!
        }else{
            let sView = UIView(frame: self.tabbarContainerView.bounds)
            sView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            sView.tag = blackTransparentViewTag
            sView.alpha = 0.06
            sView.backgroundColor = UIColor.black
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(closeSideMenu))
            sView.addGestureRecognizer(recognizer)
            return sView
        }
        
        
    }
    
    func addShadowToView(){
        //Gives Illusion that main view is above the side menu
        self.tabbarContainerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.tabbarContainerView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.tabbarContainerView.layer.shadowRadius = 1
        self.tabbarContainerView.layer.shadowOpacity = 1
        self.tabbarContainerView.layer.borderColor = UIColor.lightGray.cgColor
        self.tabbarContainerView.layer.borderWidth = 0.2
    }
    
    @objc func openOrCloseSideMenu(){
        //close
            if(hamburgerMenuIsVisible){
            let blackTransparentView = self.view.viewWithTag(self.blackTransparentViewTag)
                self.trailing.constant = 0
                blackTransparentView?.alpha = 0
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                    self.view.layoutIfNeeded()
                }) { (_) in
                    blackTransparentView?.removeFromSuperview()
                }
            self.frontVC?.tabBar.isHidden = false
            hamburgerMenuIsVisible = false
        }else {
            //open
            self.navigationItem.title = "Settings"
            self.trailing.constant = 0.8 * self.tabbarContainerView.frame.size.width
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (animationComplete) in
                print("The animation is complete!")
            }
            let blackTransparentView = self.addBlackTransparentView()

            self.tabbarContainerView.addSubview(blackTransparentView)
            self.frontVC?.tabBar.isHidden = true
     
            hamburgerMenuIsVisible = true
        }}
        
        
    @objc func closeSideMenu(){
        if(hamburgerMenuIsVisible){
        let blackTransparentView = self.view.viewWithTag(self.blackTransparentViewTag)
            self.trailing.constant = 0
            blackTransparentView?.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                blackTransparentView?.removeFromSuperview()
            }
        self.frontVC?.tabBar.isHidden = false
        hamburgerMenuIsVisible = false
        }
    }
    
    func setUpNotifications(){
           let notificationOpenOrCloseSideMenu = Notification.Name("notificationOpenOrCloseSideMenu")
           NotificationCenter.default.addObserver(self, selector: #selector(openOrCloseSideMenu), name: notificationOpenOrCloseSideMenu, object: nil)
           
           let notificationCloseSideMenu = Notification.Name("notificationCloseSideMenu")
           NotificationCenter.default.addObserver(self, selector: #selector(closeSideMenu), name: notificationCloseSideMenu, object: nil)
           
       }
       
}

    
class HamburgerMenu{
    //Class To Implement Easy Functions To Open Or Close RearView
    //Make object of this class and call functions
    func triggerSideMenu(){
        let notificationOpenOrCloseSideMenu = Notification.Name("notificationOpenOrCloseSideMenu")
        NotificationCenter.default.post(name: notificationOpenOrCloseSideMenu, object: nil)
    }
    
    func closeSideMenu(){
        let notificationCloseSideMenu = Notification.Name("notificationCloseSideMenu")
        NotificationCenter.default.post(name: notificationCloseSideMenu, object: nil)
    }
    
}
