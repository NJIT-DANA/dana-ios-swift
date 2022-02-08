//
//  ViewController.swift
//  DANA
//
//  Created by Rini Joseph on 2/5/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let currentNetworkmanager = networkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        let indicatorView = danaHelper.activityIndicator(style: .large,
                                                       center: self.view.center)
        self.view.addSubview(indicatorView)
        indicatorView.startAnimating()
        
        
        
        
        
//        currentNetworkmanager.fetchArchitectsfromDANA {
//       
//            print("finally came here")
//            indicatorView.stopAnimating()
//        }
    
    
        // Do any additional setup after loading the view.
    
    }

    
}

