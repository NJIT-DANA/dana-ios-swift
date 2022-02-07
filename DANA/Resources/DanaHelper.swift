//
//  DanaHelper.swift
//  DANA
//
//  Created by Rini Joseph on 2/5/22.
//

import Foundation
import UIKit

struct danaHelper {
    
    //check network connection for the APIcalls
    static func checkNetworkConnection()-> Bool {
        if Network.reachability.status == Network.Status.unreachable {
            return false
        }else{
            return true
        }
    }
    
    //activity indicator
    static func activityIndicator(style: UIActivityIndicatorView.Style = .medium,
                                       frame: CGRect? = nil,
                                       center: CGPoint? = nil) -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        if let frame = frame {
            activityIndicatorView.frame = frame
        }
        if let center = center {
            activityIndicatorView.center = center
        }
        return activityIndicatorView
    }
}
