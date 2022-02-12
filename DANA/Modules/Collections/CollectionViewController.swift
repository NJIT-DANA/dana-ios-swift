//
//  CollectionViewController.swift
//  DANA
//
//  Created by Littman Library on 2/6/22.
//

import UIKit
import CoreData

class CollectionViewController: UIViewController {
    let currentNetworkmanager = networkManager()
    var architectViewModel = ArchitectsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        if self.architectViewModel.checkArchitectsisEmpty(entity: textConstants.architectEntity){
            self.fetchArchitectsfromAPI()
        }
    }
    
    
    func setUI() {
        self.navigationItem.title = textConstants.collectionTitle
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
    }
    
    
    //MARK:- architect Methods
    
    func fetchArchitectsfromAPI(){
        let indicatorView = danaHelper.activityIndicator(style: .large,
                                                         center: self.view.center)
        DispatchQueue.main.async {
            self.view.addSubview(indicatorView)
            indicatorView.startAnimating()
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        architectViewModel.makeFetchArchitectsApiCall(context: context) {
            DispatchQueue.main.async {
                indicatorView.stopAnimating()
                print("finally everythings dne")
                self.fetchImagesofArchitects()
            }
            
            
        }
        
    }
    
    func fetchImagesofArchitects() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        architectViewModel.makeFetchimagesApiCall(context: context) {
           
        }
    }
}
