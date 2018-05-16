//
//  contactTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 4/29/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MBProgressHUD
import Toast
class contactTableViewCell: UITableViewCell {

    @IBOutlet weak var messageImg: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    @IBOutlet weak var twitterImg: UIImageView!
    @IBOutlet weak var whatsappImg: UIImageView!
    @IBOutlet weak var heartImg: UIImageView!
    var favourite = false
    
    var parent:ProductViewController!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    var index:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGesture = UITapGestureRecognizer(target:self,action: #selector(self.myviewTapped(_:)))
        let mobileTap = UITapGestureRecognizer(target:self,action:#selector(self.pressCall(_:)))
        
        let openChat = UITapGestureRecognizer(target:self,action:#selector(self.openChat(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.messageImg.addGestureRecognizer(openChat)
        self.messageLabel.addGestureRecognizer(openChat)
        self.phoneLabel.addGestureRecognizer(mobileTap)
        self.heartImg.addGestureRecognizer(tapGesture)
        self.phoneLabel.isUserInteractionEnabled = true
       
        
    }
    func openChat(_ sender:UITapGestureRecognizer) {
        let showChat = self.parent.storyboard?.instantiateViewController(withIdentifier: "parentChatView") as? parentChatViewController
       showChat?.chat_id =  "0"
        showChat?.otherId = self.parent.productData["user_id"] as? String ?? ""
        showChat?.otherName = self.parent.productData["user"] as? String ?? ""
        if checkUserData() {
            if self.parent.productData["user_id"] as? String == userData["id"] as? String {
                Mazad.toastView(messsage: "لا يمكن ان تراسل نفسك", view: self.parent.view)
            }else{
                self.parent.navigationController?.pushViewController(showChat!, animated: true)
            }
        }else{
            Mazad.toastView(messsage: "يجب تسجيل الدخول اولا", view: self.parent.view)
        }
        
       
    }
    func pressCall(_ sender: UITapGestureRecognizer) {
        do {
            print(phoneLabel.text)
            let phoneNum = phoneLabel.text
            if phoneNum !=  " " {
                
                phoneNum?.makeACall()
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func myviewTapped(_ sender: UITapGestureRecognizer) {
        if checkUserData() {
            MBProgressHUD.showAdded(to: self.parent.view, animated: true)
            var parameters = [String:AnyObject]()
            parameters["user_id"] = userData["id"] as AnyObject
            parameters["product_id"] = parent.product_id as AnyObject
            var url = base_url + "add_favourite"
            Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
                (response) in
                print(response)
                MBProgressHUD.hide(for: self.parent.view,animated:true)
                if let results = response.result.value as? [String:AnyObject]{
                    if results["status"] as? Bool == true {
                        if self.favourite == true {
                            self.heartImg.image = UIImage(named:"heart_product")
                            Mazad.toastView(messsage: "تم  المسح من المفضلة", view: self.parent.view)
                           
                            self.favourite = false
                            self.parent.productData["favourite"] = false
                        }else{
                            self.heartImg.image = UIImage(named:"heart_icon")
                            Mazad.toastView(messsage: "تم الاضافة الي المفضلة", view: self.parent.view)
                         
                            self.favourite = true
                            self.parent.productData["favourite"] = true
                        }
                        
                    }
                    
                }
            }
        }else {
             Mazad.toastView(messsage: "يجب تسجيل الدخول اولا", view: self.parent.view)
        }
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
