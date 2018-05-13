//
//  advancedCollectionViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 5/13/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import DropDown

class advancedCollectionViewCell: UICollectionViewCell {
    var categoryDrop = DropDown()
    var sub_id  = ""
    @IBAction func categoryAction(_ sender: Any) {
        categoryDrop.show()
    }
    @IBOutlet weak var categoryBtn: UIButton!
}
