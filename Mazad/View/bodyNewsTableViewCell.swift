//
//  bodyNewsTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 5/2/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class bodyNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bodyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
