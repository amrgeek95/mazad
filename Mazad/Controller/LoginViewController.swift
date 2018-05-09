//
//  LoginViewController.swift
//  Expand
//
//  Created by amr sobhy on 10/15/17.
//  Copyright © 2017 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import Toast
class LoginViewController: SuperParentViewController {

    @IBOutlet weak var signBtn: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let myColor = UIColor.clear
        emailText.layer.borderColor = myColor.cgColor
        passwordText.layer.borderColor = myColor.cgColor
        passwordText.setBottomBorder()
        emailText.setBottomBorder()
        passwordText.layer.borderWidth = 0.7
        emailText.layer.borderWidth = 0.7
        signBtn.borderRoundradius(radius: 10)
        
        
        
        emailText.setTextIcon(image: "user_login")
         passwordText.setTextIcon(image: "password_icon")
        self.navigationItem.title = "تسجيل الدخول"
        
       
        
        // Do any additional setup after loading the view.
      //  self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        var parameters = [String: Any]()
        
        parameters["token"] = token
      
        parameters["username"] = emailText.text
        parameters["password"] = passwordText.text
        print(parameters)
        let cart_url = base_url + "login"
        Alamofire.request(cart_url, method: .post, parameters: parameters).responseJSON{
            (response) in
            print(response)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                        if let user_data = results["user"] as? [String:AnyObject] {
                            print(user_data)
                            userData = user_data
                            saveUserData(userData: user_data as [String:AnyObject])
                            let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as? mainViewController
                            self.present(initialMain!, animated: true, completion: nil)
                        }else{
                            toastView(messsage:"Invalid Email Or Password", view: self.view)
                        }
                    }else{
                         toastView(messsage:"Invalid Email Or Password", view: self.view)
                    }
                   
                } else{
                     toastView(messsage:"Invalid Email Or Password", view: self.view)
                }
            }else{
                toastView(messsage:"Invalid Email Or Password", view: self.view)
            }
          
           
            
        }
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
