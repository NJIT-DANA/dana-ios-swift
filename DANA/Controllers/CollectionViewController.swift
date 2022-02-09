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
           // self.fetchImagesofArchitects()
           
            
    }
    
    func test() {
       
    }
//    func operationQueueforAPI(){
//        let apiOperation = BlockOperation()
//        let indicatorView = danaHelper.activityIndicator(style: .large,
//                                                       center: self.view.center)
//        DispatchQueue.main.async {
//        self.view.addSubview(indicatorView)
//        indicatorView.startAnimating()
//        }
//
//        apiOperation.addExecutionBlock {
//            if self.architectViewModel.checkArchitectsisEmpty(entity: textConstants.architectEntity){
//                self.fetchArchitectsfromAPI()
//            }
//            print("rini here 1")
//        }
//        let apiOperation2 = BlockOperation()
//        apiOperation2.addExecutionBlock{
//            print("rini here 2")
//            DispatchQueue.main.async {
//            self.view.addSubview(indicatorView)
//            indicatorView.stopAnimating()
//            }
//        }
//
//
////        apiOperation.completionBlock = {
////            DispatchQueue.main.async {
////            indicatorView.stopAnimating()
////            }
////        }
//
//        let operationQueue = OperationQueue()
////        operationQueue.addOperation(apiOperation)
//        operationQueue.addOperations([apiOperation,apiOperation2], waitUntilFinished: true)
//
//    }
//
    
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
            //call api to download the image urls
                self.fetchImagesofArchitects()
            
            }
            
        }
        
    }
    func fetchImagesofArchitects() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        architectViewModel.makeFetchimagesApiCall(context: context) {
            print("nnn")
        }
    }
}
