//
//  aboutTextTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 5/16/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast

class aboutTextTableViewCell: UITableViewCell {
    var parent : aboutViewController!
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sendAction(_ sender: Any) {
        
        
            MBProgressHUD.showAdded(to: self.parent.view, animated: true)
            var parameters = [String:Any]()
        if checkUserData(){
            parameters["email"] = userData["username"] as? AnyObject ?? ""
            var send_url = base_url + "bank_account"
            Alamofire.request(send_url, method: .post, parameters: parameters).responseJSON{
                (response) in
                MBProgressHUD.hide(for: self.parent.view, animated: true)
                Mazad.toastView(messsage: "تفقد بريدك الالكتروني", view: self.parent.view)
            }
        }else{
            Mazad.toastView(messsage: "يجب عليك التسجيل اولا", view: self.parent.view)
        }
        
            
        }
    
}
