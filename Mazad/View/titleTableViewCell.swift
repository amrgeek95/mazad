//
//  titleTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 4/29/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class titleTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
