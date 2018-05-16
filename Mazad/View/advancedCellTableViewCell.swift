//
//  advancedCellTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 5/13/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import DropDown
import Alamofire


class advancedCellTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    var parent:advancedSearchViewController!
   var dropDown = DropDown()
    var dropDown2 = DropDown()
    var sub_id = ""
    var child_id = ""
    var cat_id = ""
    
    @IBOutlet weak var childrenTop: NSLayoutConstraint!
    @IBOutlet weak var childBtn: UIButton!
    @IBOutlet weak var subBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var searchBtn: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func searchAction(_ sender: Any) {
        
        var homeView = self.parent.storyboard?.instantiateViewController(withIdentifier: "homeView") as? homeViewController
        if sub_id == "" {
            sub_id  = dropDown.selectedItem as? String ?? ""
        }
        if child_id == "" {
            child_id  = dropDown2.selectedItem as? String ?? ""
        }
        if self.sub_id != "" {
             subcategory_id = self.sub_id
        }
        if self.sub_id != "" {
           secondary_id = self.child_id
        }
        advanced_category_id = self.cat_id
        advanced_flag = true
        let initialMain = self.parent.storyboard?.instantiateViewController(withIdentifier: "mainView") as? mainViewController
        self.parent.present(initialMain!, animated: true, completion: nil)
       
        
    }
    @IBAction func childAction(_ sender: Any) {
        dropDown2.show()
    }
    @IBAction func subAction(_ sender: Any) {
        dropDown.show()
    }
}
