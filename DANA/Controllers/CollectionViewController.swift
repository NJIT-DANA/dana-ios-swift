//
//  CollectionViewController.swift
//  DANA
//
//  Created by Littman Library on 2/6/22.
//

import UIKit

class CollectionViewController: UIViewController {
let currentNetworkmanager = networkManager()
        override func viewDidLoad() {
            super.viewDidLoad()
            self.setUI()
            let indicatorView = danaHelper.activityIndicator(style: .large,
                                                           center: self.view.center)
            self.view.addSubview(indicatorView)
            indicatorView.startAnimating()
            
            
            
            
            
//            currentNetworkmanager.fetchArchitectsfromDANA {
//
//                print("finally came here")
//                indicatorView.stopAnimating()
//            }
//

//            currentNetworkmanager.fetchBuildingsfromDANA {
//                print("finally came here")
//                indicatorView.stopAnimating()
//            }
//            currentNetworkmanager.fetchPublicSpacesfromDANA {
//
//                print("finally came here")
//                indicatorView.stopAnimating()
//            }
            currentNetworkmanager.fetchPublicArtfromDANA {
                print("finally came here")
                indicatorView.stopAnimating()
            }
    }
    

    func setUI() {
        self.navigationItem.title = textConstants.collectionTitle
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
    }

}
