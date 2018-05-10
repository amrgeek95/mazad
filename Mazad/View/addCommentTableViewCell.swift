//
//  addCommentTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 4/29/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast

class addCommentTableViewCell: UITableViewCell {
    var parent:ProductViewController!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addBtn.borderRound(border: 0.2, corner: 10)
        self.commentText.textAlignment = .right
        // self.commentText.placeholder = "اكتب تعليق"
    }
    
    @IBAction func addAction(_ sender: Any) {
        if checkUserData() {
            
            
            if self.commentText.text != "" {
                self.addBtn.isEnabled == false
                MBProgressHUD.showAdded(to: self.parent.view, animated: true)
                var parameters = [String:AnyObject]()
                parameters["user_id"] = userData["id"] as AnyObject
                parameters["product_id"] = parent.product_id as AnyObject
                parameters["comment"] = self.commentText.text as AnyObject
                var url = base_url + "add_comment"
                Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
                    (response) in
                    print(response)
                    MBProgressHUD.hide(for: self.parent.view,animated:true)
                    if let results = response.result.value as? [String:AnyObject]{
                        
                        self.addBtn.isEnabled == true
                    
                        var commentList = ["user":userData["name"],"comment":self.commentText.text]
                        self.commentText.text = ""
                        self.parent.commentData.append(commentList)
                        self.parent.productTableView.reloadData()
                        if results["status"] as? Bool == true {
                            self.parent.view.makeToast(results["message"] as? String)
                        }
                        
                    }
                }
            }else {
                self.parent.view.makeToast("من فضلك اكتب تعليق اولا")
            }
        } else {
            Mazad.toastView(messsage: "يجب تسجيل الدخول اولا", view: self.parent.view)
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
