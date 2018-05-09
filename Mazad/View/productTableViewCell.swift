//
//  productTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 4/25/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast

class productTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var favouriteIcon: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var parent:homeViewController!
    var indexNumber:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGesture = UITapGestureRecognizer(target:self,action: #selector(self.myviewTapped(_:)))
        
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.favouriteIcon.isUserInteractionEnabled = true
        self.favouriteIcon.addGestureRecognizer(tapGesture)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func myviewTapped(_ sender: UITapGestureRecognizer) {
        MBProgressHUD.showAdded(to: self.parent.view, animated: true)
        var parameters = [String:AnyObject]()
        parameters["user_id"] = userData["id"] as AnyObject
        parameters["product_id"] = parent.productListArray[indexNumber]["id"] as AnyObject
        var url = base_url + "add_favourite"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            (response) in
            print(response)
            MBProgressHUD.hide(for: self.parent.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                if results["status"] as? Bool == true {
                    
                    self.parent.productListArray.remove(at: self.indexNumber)
                    self.parent.productTableView.reloadData()
                }
                
            }
        }
    }
    
}
