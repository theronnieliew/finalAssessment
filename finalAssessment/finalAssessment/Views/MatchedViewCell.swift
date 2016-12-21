//
//  MatchedViewCell.swift
//  finalAssessment
//
//  Created by Ronald Liew on 21/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit

class MatchedViewCell: UITableViewCell {
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
