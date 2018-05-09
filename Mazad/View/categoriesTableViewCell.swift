//
//  categoriesTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 4/26/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class categoriesTableViewCell: UITableViewCell {
 
    
    @IBOutlet weak var notification: UISwitch!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.borderRound(border: 0.5, corner: 10)
        containerView.dropShadow()
    }

    @IBAction func notificationAction(_ sender: Any) {
    }
    @IBOutlet weak var categoryName: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
