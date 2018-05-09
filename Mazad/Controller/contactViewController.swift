//
//  contactViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/28/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast
class contactViewController: SuperParentViewController {

    @IBAction func sendAction(_ sender: Any) {
    }
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendBtn.addTarget(self, action: #selector(self.send_feedback(sender:)), for: .touchUpInside)
        labelName.text = "اسم المستخدم : \(  userData["name"] as? String ?? "")"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = " تواصل معنا "
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#394044")
        sendBtn.borderRoundradius(radius: 10)
    }
    func send_feedback(sender:UIButton){
        guard inputValidation(text: self.messageText.text!, message: "يجب كتابة محتوي", view: self.view) else {
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:Any]()
        parameters["user_id"] = userData["id"] as? AnyObject ?? ""
        parameters["comment"] = self.messageText.text
        var send_url = base_url + "send_feedback"
        Alamofire.request(send_url, method: .post, parameters: parameters).responseJSON{
            (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch response.result {
            case .success:
                Mazad.toastView(messsage: "تم ارسال رسالتك", view: self.view)
            case .failure:
                Mazad.toastView(messsage: "حدث خطأ", view: self.view)
                break;
            }
        }
        
    }
   
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
