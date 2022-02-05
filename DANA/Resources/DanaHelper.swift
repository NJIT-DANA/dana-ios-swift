//
//  DanaHelper.swift
//  DANA
//
//  Created by Rini Joseph on 2/5/22.
//

import Foundation
struct danaHelper{

   //check network connection for the apis
   static func checkNetworkConnection()-> Bool{
        if Network.reachability.status == Network.Status.unreachable {
            return false
        }else{
            return true
        }
    }
}
