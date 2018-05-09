//
//  menuTableViewCell.swift
//  Expand
//
//  Created by amr sobhy on 10/23/17.
//  Copyright © 2017 amr sobhy. All rights reserved.
//

import UIKit

class menuTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let margins = containerView.layoutMarginsGuide
        label.textAlignment = NSTextAlignment.right
        
       // img.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10).isActive = true
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
