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

class aboutTextTableViewCell: UITableViewCell ,UITextFieldDelegate{
    var parent : aboutViewController!
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization codes
        text2.isEnabled = false
        text1.delegate = self
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
           
            guard let total = textField.text as? String else { return }
            if !total.isEmpty {
                text2.text = "\(Double(total)! * 0.005 )"
                
            }
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sendAction(_ sender: Any) {
        var parameters = [String:Any]()
        if checkUserData(){
            parameters["email"] = userData["username"] as? AnyObject ?? ""
            var send_url = base_url + "bank_account"
            Alamofire.request(send_url, method: .post, parameters: parameters).responseJSON{
                (response) in
                 Mazad.toastView(messsage: "تفقد بريدك الالكتروني", view: self.parent.view)
            }
        }else{
             Mazad.toastView(messsage: "يجب عليك التسجيل اولا", view: self.parent.view)
        }
    }
    
}
