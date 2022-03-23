//
//  DANAHomeTableViewCell.swift
//  DANA
//
//  Created by Littman Library on 3/8/22.
//

import UIKit

class DANAHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var explorelabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var collectionimageView: UIImageView!
    
    
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        collectionimageView.layer.cornerRadius = 5
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = false
        containerView.layer.shadowOpacity = 0.0
        containerView.layer.shadowRadius = 0.0
        if self.traitCollection.userInterfaceStyle == .dark{
            containerView.backgroundColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUI(){
        //        containerView.layer.masksToBounds = false
        //        containerView.layer.shadowColor = UIColor.black.cgColor
        //        containerView.layer.shadowOpacity = 0.5
        //        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        containerView.layer.shadowRadius = 5
        //        collectionimageView.layer.cornerRadius = 5
        //        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        ////        containerView.layer.shouldRasterize = true
        ////        containerView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
}
