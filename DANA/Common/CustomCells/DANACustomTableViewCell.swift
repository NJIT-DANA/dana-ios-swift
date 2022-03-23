//
//  DANACustomTableViewCell.swift
//  DANA
//
//  Created by Littman Library on 2/8/22.
//

import UIKit

class DANACustomTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
 
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureView.contentMode = UIView.ContentMode.scaleToFill
        pictureView.layer.cornerRadius = 5
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

}
