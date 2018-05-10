//
//  SignUpViewController.swift
//  Expand
//
//  Created by amr sobhy on 12/7/17.
//  Copyright © 2017 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import Toast
class SignUpViewController: SuperParentViewController {

     @IBOutlet weak var nameText: UITextField!
     @IBOutlet weak var mobileText: UITextField!
     @IBOutlet weak var emailText: UITextField!
     @IBOutlet weak var passwordText: UITextField!
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
        passwordText.layer.borderColor = myColor.cgColor
        
        nameText.layer.borderWidth = 0.7
        mobileText.layer.borderWidth = 0.7
        emailText.layer.borderWidth = 0.7
        passwordText.layer.borderWidth = 0.7
        self.navigationItem.title = "التسجيل"
        
        nameText.setTextIcon(image: "user_login")
        mobileText.setTextIcon(image: "phone_signup")
        emailText.setTextIcon(image: "email_icon")
        passwordText.setTextIcon(image: "password_icon")
        
        nameText.setBottomBorder()
        mobileText.setBottomBorder()
        emailText.setBottomBorder()
        passwordText.setBottomBorder()
        
    }

    @IBAction func signUpBtn(_ sender: Any) {
        var parameters = [String: Any]()
        let name =  nameText.text
         let mobile =  mobileText.text
         let uEmail =  emailText.text
         let uPassword =  passwordText.text
     
  
        guard self.checkValidation(name: name!, email: uEmail!, mobile: mobile!, password: uPassword!) else {
            return
        }
        
        if Reachability.isConnectedToNetwork(){
            parameters["token"] = token
            parameters["name"] = name
            parameters["mobile"] = mobile
            parameters["email"] = emailText.text
            parameters["password"] = passwordText.text
                  print(parameters)
            let register_url = base_url + "signup"
            print(register_url)
            Alamofire.request(register_url, method: .post, parameters: parameters).responseJSON{
                (response) in
                print(response)
                let results = response.result.value as? [String:AnyObject]
                if results!["status"] as? Bool == true {
                    if let user_data = results!["user"] as? [String:AnyObject] {
                        print(userData)
                        saveUserData(userData: user_data as [String:AnyObject])
                        userData = user_data
                        let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as? mainViewController
                        self.present(initialMain!, animated: true, completion: nil)
                    }
                }else{
                    toastView(messsage:results!["message"] as? String ?? "", view: self.view)
                }
                
                
            }
        }else{
            self.view.makeToast("يرجي التأكد من وجود شبكة ")
        }
       
    }
    func checkValidation(name: String,email: String, mobile: String, password:String ) -> Bool{
        
        if name.isEmpty{
          
            toastView(messsage: "يجب كتابة اسم المستخدم", view: self.view)
            return false
        }
        if mobile.isEmpty{
            toastView(messsage:"يجب كتابة رقم الجوال", view: self.view)
            return false
        }
        
        if mobile.characters.count != 10 {
            toastView(messsage:"يرجي كتابة ١٠ ارقام صحيحة للجوال", view: self.view)
            return false
        }
        if email.isEmpty{
            toastView(messsage:"يرجي ادخال البريد الالكتروني", view: self.view)
            return false
        }else if !Utilities.isEmailValidation(email){
            toastView(messsage:"ادخل البريد بطريقة صحيحة", view: self.view)
            return false
        }
        
       
        
        if password.isEmpty{
            toastView(messsage:"يجب ادخال كلمة المرور", view: self.view)
            return false
        }
        
        return true
        
    }
    @IBOutlet weak var signup: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var homeBack: UIButton!
    @IBAction func homeAction(_ sender: Any) {
        let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as? mainViewController
        self.present(initialMain!, animated: true, completion: nil)
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
