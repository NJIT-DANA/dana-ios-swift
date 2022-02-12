//
//  DANACustomTableViewCell.swift
//  DANA
//
//  Created by Littman Library on 2/8/22.
//

import UIKit

class DANACustomTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
 
    @IBOutlet weak var pictureView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        pictureView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        pictureView.contentMode = UIView.ContentMode.scaleToFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
