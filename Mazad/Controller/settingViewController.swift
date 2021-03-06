//
//  settingViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/29/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast

class settingViewController: SuperParentViewController ,UITableViewDataSource , UITableViewDelegate {
      var categoriesList = [Dictionary<String,Any>]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          if indexPath.section == 0 {
            if indexPath.row == 0 {
                let shareText = "حمل تطبيق مزاد"
                let urlshare = URL (string: "https://itunes.apple.com/app/id1379913224" as! String)
                 //check ipad
                let activityViewController = UIActivityViewController(activityItems: [urlshare], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.layer.bounds.width * 0.3,y: self.view.layer.bounds.height * 0.5,width: 0.00, height: 0.0)
                self.present(activityViewController, animated: true, completion: nil)
            }else if indexPath.row == 1 {
                if let url = URL(string: "itms-apps://itunes.apple.com/app/id1379913224"),
                    UIApplication.shared.canOpenURL(url)
                {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell") as? categoriesTableViewCell
            cell?.categoryName.setTitle( categoriesList[indexPath.row]["name"] as? String ?? "", for: .normal)
            cell?.img.image =  UIImage(named: categoriesList[indexPath.row]["image"] as? String ?? "")
            cell?.img.contentMode = .scaleAspectFit
            if indexPath.row != 2 {
                cell?.notification.isHidden = true
            }
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as? settingTableViewCell
            cell?.deleteFavourite.borderRound(border: 0.2, corner: 7)
            if checkUserData(){
                cell?.deleteFavourite.addTarget(self, action: #selector(self.deleteFavourite(sender:)), for: .touchUpInside)
                cell?.deleteSearch.addTarget(self, action: #selector(self.deleteSearch(sender:)), for: .touchUpInside)
                
            }
            
            cell?.deleteSearch.borderRound(border: 0.2, corner: 7)
            
            return cell!
        }
    }
    func deleteSearch(sender:UIButton){
        let alertController = UIAlertController(title: nil, message: "هل انت متاكد من مسح سجل البحث", preferredStyle: .actionSheet)
        
        
        let deleteAction = UIAlertAction(title: "مسح", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            self.delete_search()
        })
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
        })
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true, completion: nil)
    }
    func deleteFavourite(sender:UIButton){
        let alertController = UIAlertController(title: nil, message: "هل انت متاكد من مسح المفضلة", preferredStyle: .actionSheet)
        
        
        let deleteAction = UIAlertAction(title: "مسح", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            self.delete_favourite()
        })
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
        })
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)

        
    }
    func delete_favourite(){
        var parameters = [String:AnyObject]()
        parameters["user_id"] = userData["id"] as AnyObject
        var delete_url = base_url + "delete_favourite"
        print(parameters)
        
        Alamofire.request(delete_url, method: .post, parameters: parameters).responseJSON{
            (response) in
            if let result = response.result.value as? [String:AnyObject]{
                if let status = result["status"] as? Bool {
                    if status == true {
                        Mazad.toastView(messsage: "تم مسح المفضلة", view: self.view)
                    }
                }
            }
        }
    }
    func delete_search(){
        var parameters = [String:AnyObject]()
        parameters["user_id"] = userData["id"] as AnyObject
        var delete_url = base_url + "delete_search"
        print(parameters)
        
        Alamofire.request(delete_url, method: .post, parameters: parameters).responseJSON{
            (response) in
            if let result = response.result.value as? [String:AnyObject]{
                if let status = result["status"] as? Bool {
                    if status == true {
                        Mazad.toastView(messsage: "تم المسح", view: self.view)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var settingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesList = [["name":"مشاركة التطبيق","image":"share_icon"],
                          ["name":"تقييم التطبيق" ,"image":"star_rate_icon"],
                          ["name":"الاشعارات","image":"alarm_icon"]]
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = " الاعدادات "
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#394044")
        
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
