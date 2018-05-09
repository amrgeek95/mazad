//
//  newsTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 4/26/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class newsTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleBtn: UIButton!
    @IBOutlet weak var notificationImg: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsImg: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
