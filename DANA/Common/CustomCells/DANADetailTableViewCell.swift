//
//  DANADetailTableViewCell.swift
//  DANA
//
//  Created by Littman Library on 3/15/22.
//

import UIKit

class DANADetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        if self.traitCollection.userInterfaceStyle == .dark{
            detaildescriptionLabel.textColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)//UIColor.lightGray
        }
    }

    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var detaildescriptionLabel: UILabel!
    @IBOutlet weak var detailtitleLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
