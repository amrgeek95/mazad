//
//  resetPasswordViewController.swift
//  Mazad
//
//  Created by amr sobhy on 5/17/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast
class resetPasswordViewController: SuperParentViewController {
    
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var code: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        signup.borderRoundradius(radius: 10)
        
        let myColor = UIColor.clear
        
        code.layer.borderColor = myColor.cgColor
        code.layer.borderWidth = 0.7
        password.layer.borderColor = myColor.cgColor
        password.layer.borderWidth = 0.7
        self.navigationItem.title = "اعادة تعيين كلمة المرور"
        code.setTextIcon(image: "email_icon")
        code.setBottomBorder()
        password.setTextIcon(image: "email_icon")
        password.setBottomBorder()
        self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceRightToLeft
        
    }
    
    
    @IBAction func signUpBtn(_ sender: Any) {
        var parameters = [String: Any]()
        let codeText =  code.text
         let passwordText =  password.text
        guard inputValidation(text: codeText!, message: "يجب كتابة كود التفعيل", view: self.view) else{
            return
        }
        guard inputValidation(text: passwordText!, message: "ادخل كلمة المرور", view: self.view) else{
            return
        }
        
        if Reachability.isConnectedToNetwork(){
            parameters["verification"] = codeText
            parameters["new_password"] = passwordText
            print(parameters)
            let register_url = base_url + "change_password"
            print(register_url)
            Alamofire.request(register_url, method: .post, parameters: parameters).responseJSON{
                (response) in
                print(response)
                let results = response.result.value as? [String:AnyObject]
                if results!["status"] as? Bool == true {
                    let show = self.storyboard?.instantiateViewController(withIdentifier: "preLogin") as? preLoginViewController
                    self.navigationController?.pushViewController(show!, animated: true)
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
