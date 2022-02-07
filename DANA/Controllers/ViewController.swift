//
//  ViewController.swift
//  DANA
//
//  Created by Rini Joseph on 2/5/22.
//

import UIKit

class ViewController: UIViewController {
    let currentNetworkmanager = networkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
//        if danaHelper.checkNetworkConnection(){
//            print("connected")
//        }
//            else {
//                print("notconnected")
//            }
//        }
        //currentNetworkmanager.fetchMaplocationsfromDANA()
        currentNetworkmanager.fetchPublicArtfromDANA {
            
      
            
            print("finally came here")
        }
        // Do any additional setup after loading the view.
    }
//this is to test the git

}

