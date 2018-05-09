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
            }
            
            cell?.deleteSearch.borderRound(border: 0.2, corner: 7)
            return cell!
        }
    }
    func deleteFavourite(sender:UIButton){
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
