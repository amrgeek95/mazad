
//
//  MenuController.swift
//  ABC
//
//  Created by MacBook Pro on 4/2/17.
//  Copyright © 2017 Amrsobhy. All rights reserved.
//

import UIKit
import Alamofire
import SideMenuController


class MenuController: UITableViewController ,SideMenuControllerDelegate{
    let delegate =  UIApplication.shared.delegate as! AppDelegate
    
    
    
    @IBOutlet var menuTableView: UITableView!
    var window: UIWindow?
    private var previousIndex: NSIndexPath?
    
    var menu_items = ["الرئيسية"
        ,"بحث متخصص"
        
        ,"اعلن معنا "
        ,"الاقسام "
        ,"المفضلة"
        ,"تواصل معنا"
        ,"عمولة وانظمة مزاد"
        ,"اعلاناتي"
        ,"تسجيل الخروج"]
    var menu_items_image = ["home_icon_active","search_menu","ads_menu","ads_menu","favourite_menu",
                            "contact_menu","percent_menu","user_icon","logout_menu"]
    var segues = ["showHome","showCategories","showCategories","showCategories","showHome","showContact","showContact","showHome","showHome"]
    
    
    var actionSheet: UIAlertController!
    
    
    // Remove the LCLLanguageChangeNotification on viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        viewadded?.removeFromSuperview()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        
        // setupBackgroundColor()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        print("whymenu")
        //  self.menuTableView.backgroundColor = UIColor.white
        // self.menuTableView.backgroundView = GradientView()
        
    }
    var viewadded: UIView?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkUserData() {
            return menu_items.count
        }else{
            return 8
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuTableViewCell
        cell.label.text = menu_items[indexPath.row];
        
        cell.img.image = UIImage(named:"\(menu_items_image[indexPath.row])")
        if indexPath.row == menu_items.count - 1 {
            cell.label.textColor  = UIColor.red
        }
         if !checkUserData() {
            if indexPath.row == 7 {
                cell.img.image = UIImage(named:"login_menu")
                cell.label.text = "تسجيل الدخول"
                cell.label.textColor = UIColor(hexString:"#249C6B")
            }
         }
       
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        my_products = 0
        filter_category = 0
        add_product_flag = 0
        my_favourites = 0
        if indexPath.row == 0 {
            let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as? mainViewController
            self.present(initialMain!, animated: true, completion: nil)
        } else {
            if indexPath.row == 2 {
                if checkUserData() {
                    saveSegue(data: true, name: "add_product_flag")
                    add_product_flag = 1
                    
                }else{
                    
                    let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as? mainViewController
                    self.present(initialMain!, animated: true, completion: nil)
                    
                }
                
                
            }
            if indexPath.row == 3 {
                saveSegue(data: true, name: "filter_category")
                filter_category = 1
                
                
            }
            if indexPath.row == 4 {
                if checkUserData() {
                    my_favourites = 1
                    
                    
                }else{
                    let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as? mainViewController
                    self.present(initialMain!, animated: true, completion: nil)
                }
                
            }
            if indexPath.row == 7 {
                if checkUserData(){
                    
                    my_products = 1
                }else{
                 
                    let show = self.storyboard?.instantiateViewController(withIdentifier: "preLogin") as? preLoginViewController
                   self.present(show!, animated: true, completion: nil)
                }
            }
            if indexPath.row == 8 {
                removeUserData()
                let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as? mainViewController
                self.present(initialMain!, animated: true, completion: nil)
            }
            if let index = previousIndex {
                tableView.deselectRow(at: index as IndexPath, animated: true)
            }
            sideMenuController?.performSegue(withIdentifier: segues[indexPath.row], sender: nil)
            
        }
        
        print(segues[indexPath.row])
        
        //sideMenuController?.embed(centerViewController: nc1)
        
        previousIndex = indexPath as NSIndexPath?
        
        
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        //  dismiss(animated: true, completion: nil)
        /*
         if let controller = sideMenuController?.viewController(forCacheIdentifier: controllerType.cacheIdentifier) {
         
         }
         */
        //sideMenuController?.embed(centerViewController: nc1)
    }
    
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        print(#function)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
