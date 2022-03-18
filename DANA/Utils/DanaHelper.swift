//
//  DanaHelper.swift
//  DANA
//
//  Created by Rini Joseph on 2/5/22.
//

import Foundation
import UIKit
import CoreData

struct danaHelper {
    
    //check network connection for the APIcalls
    static func checkNetworkConnection()-> Bool {
        if Network.reachability.status == Network.Status.unreachable {
            return false
        }else{
            return true
        }
    }
    
   static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
    
    //check if  DB is empty for architects
    static func checkifEntityisEmpty(entity:String)->Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var isEmpty = false
        request.fetchLimit = 1
        do{
            let count = try context.count(for: request)
            if(count == 0){
                isEmpty = true;
            }
            else{
                isEmpty = false;
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return isEmpty
    }
  
    
}
