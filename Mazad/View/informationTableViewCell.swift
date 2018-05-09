//
//  informationTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 4/29/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class informationTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
