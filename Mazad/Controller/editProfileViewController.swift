//
//  editProfileViewController.swift
//  Mazad
//
//  Created by amr sobhy on 5/8/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast

class editProfileViewController: SuperParentViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var mobileText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        signup.borderRoundradius(radius: 10)
        
        let myColor = UIColor.clear
        nameText.layer.borderColor = myColor.cgColor
        mobileText.layer.borderColor = myColor.cgColor
        emailText.layer.borderColor = myColor.cgColor
        
        nameText.layer.borderWidth = 0.7
        mobileText.layer.borderWidth = 0.7
        emailText.layer.borderWidth = 0.7
       
        self.navigationItem.title = userData["name"] as? String ?? ""
        
        nameText.setTextIcon(image: "user_login")
        mobileText.setTextIcon(image: "phone_signup")
        emailText.setTextIcon(image: "email_icon")
        
        nameText.setBottomBorder()
        mobileText.setBottomBorder()
        emailText.setBottomBorder()
        
        self.nameText.text = userData["name"]  as? String ?? ""
        self.emailText.text = userData["username"] as? String ?? ""
        self.mobileText.text = userData["mobile"] as? String ?? ""
       
        
        
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        var parameters = [String: Any]()
        let name =  nameText.text
        let mobile =  mobileText.text
        let uEmail =  emailText.text
        
        
        guard self.checkValidation(name: name!, email: uEmail!, mobile: mobile!) else {
            return
        }
        
        if Reachability.isConnectedToNetwork(){
            parameters["id"] = userData["id"]
            parameters["name"] = name
            parameters["mobile"] = mobile
            parameters["email"] = emailText.text
            print(parameters)
            let register_url = base_url + "edit"
            print(register_url)
            Alamofire.request(register_url, method: .post, parameters: parameters).responseJSON{
                (response) in
                print(response)
                let results = response.result.value as? [String:AnyObject]
                if results!["status"] as? Bool == true {
                    userData["name"] = name
                    userData["username"] = uEmail
                    userData["mobile"] = mobile
                    
                    saveUserData(userData: userData as [String : AnyObject] )
                    let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as? mainViewController
                    self.present(initialMain!, animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    toastView(messsage:"البريد الالكتروني مستخدم من قبل", view: self.view)
                }
                
                
            }
        }else{
            self.view.makeToast("Check Network Connection")
        }
        
    }
    func checkValidation(name: String,email: String, mobile: String) -> Bool{
        
        if name.isEmpty{
            
            toastView(messsage: "Name IS Required", view: self.view)
            return false
        }
        if mobile.isEmpty{
            toastView(messsage:"mobile Is Required", view: self.view)
            return false
        }
        if email.isEmpty{
            toastView(messsage:"Email is required", view: self.view)
            return false
        }else if !Utilities.isEmailValidation(email){
            toastView(messsage:"Please Enter a valid email", view: self.view)
            return false
        }
      
        
        return true
        
    }
    @IBOutlet weak var signup: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
