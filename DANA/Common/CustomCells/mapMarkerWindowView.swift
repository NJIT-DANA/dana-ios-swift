//
//  mapMarkerWindowView.swift
//  DANA
//
//  Created by Littman Library on 3/11/22.
//

import Foundation
import UIKit

protocol MapMarkerDelegate: AnyObject {
    func didTapInfoButton(data: NSDictionary)
}
class mapMarkerWindowView: UIView {
    @IBOutlet weak var descriptionLabel: UILabel!
    weak var delegate: MapMarkerDelegate?
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    
    @IBAction func closeView(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
    
    class func instanceFromNib() -> UIView {
           return UINib(nibName: "MarkerView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
       }
    
    
    
    
    
}
