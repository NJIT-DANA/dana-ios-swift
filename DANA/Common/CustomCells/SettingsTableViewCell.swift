//
//  SettingsTableViewCell.swift
//  DANA
//
//  Created by Littman Library on 3/15/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var descrtiptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
