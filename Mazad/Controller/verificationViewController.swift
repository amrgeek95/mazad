//
//  verificationViewController.swift
//  Mazad
//
//  Created by amr sobhy on 5/17/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast
class verificationViewController: SuperParentViewController {
    
   
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        signup.borderRoundradius(radius: 10)
        
        let myColor = UIColor.clear
       
        emailText.layer.borderColor = myColor.cgColor
        emailText.layer.borderWidth = 0.7
        self.navigationItem.title = "نسيت كلمة المرور"
        emailText.setTextIcon(image: "email_icon")
        emailText.setBottomBorder()
        self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceRightToLeft
        
    }
    
    
    @IBAction func signUpBtn(_ sender: Any) {
        var parameters = [String: Any]()
        let uEmail =  emailText.text
        guard self.checkValidation(email: uEmail!) else {
            return
        }
        
        if Reachability.isConnectedToNetwork(){
            parameters["email"] = emailText.text
            print(parameters)
            let register_url = base_url + "forget_password"
            print(register_url)
            Alamofire.request(register_url, method: .post, parameters: parameters).responseJSON{
                (response) in
                print(response)
                let results = response.result.value as? [String:AnyObject]
                if results!["status"] as? Bool == true {
                  self.performSegue(withIdentifier: "resetPassword", sender: nil)
                }else{
                    toastView(messsage:results!["message"] as? String ?? "", view: self.view)
                }
                
            }
        }else{
            self.view.makeToast("يرجي التأكد من وجود شبكة ")
        }
        
    }
    func checkValidation(email: String) -> Bool{
        
       if email.isEmpty{
            toastView(messsage:"يرجي ادخال البريد الالكتروني", view: self.view)
            return false
        }else if !Utilities.isEmailValidation(email){
            toastView(messsage:"ادخل البريد بطريقة صحيحة", view: self.view)
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
