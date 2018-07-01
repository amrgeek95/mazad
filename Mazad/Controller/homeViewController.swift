//
//  homeViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/25/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import SideMenuController
import Alamofire
import MBProgressHUD
import Toast
class homeViewController: SuperParentViewController ,UITableViewDelegate,UITableViewDataSource , sendSearchData{
    
    
    @IBOutlet weak var leftBtnItem: UIBarButtonItem!
    var category_id = ""
    var selected_index:Int!
    var city_id = ""
    var model_id = ""
   
    @IBAction func leftBtnAction(_ sender: Any) {
        
    }
    func sendData(city_id: String, year_id: String) {
        self.city_id = city_id
        self.model_id = year_id
        print("year Selected \(model_id)")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print(productListArray.count)
        if productListArray.isEmpty {
            return 0
        }
        return productListArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if my_products == 1 {
            let closeAction = UIContextualAction(style: .normal, title:  "مسح", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("OK, marked as Closed")
                self.selected_index = indexPath.row
                self.deleteProduct()
                success(true)
            })
            
            //closeAction.image = UIImage(named: "user_icon")
            closeAction.backgroundColor = .red
            
            return UISwipeActionsConfiguration(actions: [closeAction])
        }else {
            return UISwipeActionsConfiguration()
        }
    }
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if my_products == 1 {
            let closeAction = UIContextualAction(style: .normal, title:  "مسح", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("OK, marked as Closed")
                self.selected_index = indexPath.row
                self.deleteProduct()
                success(true)
            })
        
        //closeAction.image = UIImage(named: "user_icon")
        closeAction.backgroundColor = .red
        
            return UISwipeActionsConfiguration(actions: [closeAction])
        }else {
            return UISwipeActionsConfiguration()
        }
        
        
    }
    func deleteProduct(){
        var parameters = [String:AnyObject]()
        parameters["user_id"] = userData["id"] as AnyObject
        parameters["id"] = self.productListArray[selected_index]["id"] as AnyObject
        print(parameters)
        var url = base_url + "delete_product"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            (response) in
            print(response)
            switch response.result{
            case .success:
                if let results = response.result.value as? [String:AnyObject]{
                    
                    if results["status"] as? Bool == true {
                        self.productListArray.remove(at: self.selected_index)
                        self.productTableView.reloadData()
                    }
                }
            case .failure:
                Mazad.toastView(messsage: "حدث خطا", view: self.view)
            }
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell") as? productTableViewCell
        print(productListArray)
        if !productListArray.isEmpty {
            cell?.cityLabel.text = productListArray[indexPath.row]["city"] as? String ?? ""
            cell?.nameLabel.text = productListArray[indexPath.row]["name"] as? String ?? ""
            cell?.userLabel.text = productListArray[indexPath.row]["user"] as? String ?? ""
            // cell?.productImage.imag = productListArray[indexPath.row]["city"] as? String ?? ""
            // cell?.productImage.sd_setImage(with: productListArray[indexPath.row]["image"] as? String ?? "", placeholderImage: UIImage(named: "car_icon"))
            if my_favourites == 1 {
                cell?.favouriteIcon.isHidden = false
            }else{
                
                cell?.favouriteIcon.isHidden = true
            }
            cell?.productImage.sd_setImage(with: URL(string: productListArray[indexPath.row]["image"] as? String ?? ""), placeholderImage: UIImage(named: "logo"))
           
            cell?.productImage.layer.cornerRadius = 10
            
            cell?.productImage.layer.masksToBounds = true
            cell?.productImage.layer.borderWidth = 3
            cell?.productImage.layer.borderColor = UIColor.lightGray.cgColor
            cell?.productImage.layer.cornerRadius = 20
            cell?.productImage.contentMode = .scaleAspectFill
            
            
            cell?.parent = self
            cell?.indexNumber = indexPath.row
        }
       
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    
    var productListArray = [Dictionary<String,Any>]()
    @IBOutlet weak var productTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        productListArray.removeAll()
    
        let nib = UINib.init(nibName: "productTableViewCell", bundle: nil)
        self.productTableView.register(nib, forCellReuseIdentifier: "productTableViewCell")
        
        self.productTableView.backgroundView?.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
 
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let imagebar = UIImage(named: "24_icon")
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        button.setImage(imagebar, for: .normal)
        
        button.addTarget(self, action: #selector(self.clickOnTitle), for: .touchUpInside)
        self.navigationItem.titleView = button
        
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  my_favourites == 1 {
            return 
        }
        
        let showProduct = self.storyboard?.instantiateViewController(withIdentifier: "productView") as? ProductViewController
        showProduct?.product_id = productListArray[indexPath.row]["id"] as! String
        self.navigationController?.pushViewController(showProduct!, animated: true)
        //self.performSegue(withIdentifier: "showProduct", sender: nil)
    }
    func clickOnTitle(button: UIButton) {
        self.performSegue(withIdentifier: "showNews", sender: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#394044")
       
        self.navigationItem.title = "الرئيسية"
        self.productListArray.removeAll()
        get_products()
      
        let button = UIButton(type: .system)
        if checkUserData() == true {
            print(checkUserData())
            
            button.frame = CGRect(x: 0.0, y: 0.0, width: 80, height: 40)
            button.setImage(UIImage(named: "user_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            button.imageView?.contentMode = .scaleAspectFit
            button.setTitle(userData["name"] as? String ?? "", for: .normal)
            button.addTarget(self, action: #selector(self.showProfile(sender:)), for: .touchUpInside)
            
        } else {
            
            button.frame = CGRect(x: 0.0, y: 0.0, width: 50, height: 35)
            button.setImage(UIImage(named: "new_user_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.sizeThatFits(CGSize(width: 40, height: 30))
            //button.sizeToFit()
            button.addTarget(self, action: #selector(self.loginAction), for: .touchUpInside)
            
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
 
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginAction(sender:UIButton){
        self.performSegue(withIdentifier: "showPreLogin", sender: nil)
    }
    func showProfile(sender:UIButton){
        let show = self.storyboard?.instantiateViewController(withIdentifier: "editProfileView") as? editProfileViewController
        self.navigationController?.pushViewController(show!, animated: true)
        
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
extension homeViewController{
    func get_products(){
        self.productListArray.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:AnyObject]()
         var url = base_url + "get_products"
        if my_products == 1 {
        if checkUserData(){
           
                 parameters["user_id"] = userData["id"] as AnyObject
            }
        } else if  filter_category == 1 {
            parameters["category_id"] = global_category_id as AnyObject
        }
        else if  my_favourites == 1 {
            url = base_url + "my_favourites"
            parameters["user_id"] = userData["id"] as AnyObject
        }
        if advanced_flag == true {
            if subcategory_id != "" {
                parameters["subcategory_id"] = subcategory_id as AnyObject
            }
            if secondary_id != "" {
                parameters["secondary_id"] = secondary_id as AnyObject
            }
        }
        if city_id != "" {
            parameters["city_id"] = self.city_id as AnyObject
        }
        if model_id != "" {
            parameters["model_id"] = self.city_id as AnyObject
        }
       
        
        print("my_products\(my_products)")
        print("filter_category\(filter_category)")
         print("global_category_id\(global_category_id)")
        print("my_favourites\(my_favourites)")
        
        print(parameters)
       
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            (response) in
             MBProgressHUD.hide(for: self.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
               
                advanced_flag = false
                if  let result = results["products"] as? [[String:AnyObject]] {
                    print(result)
                    for str:[String:AnyObject] in result {
                        print(str)
                        
                        var each_list = [String:AnyObject]()
                        
                        each_list["name"] =  str["name"]! as AnyObject
                        each_list["id"] =  str["id"] as AnyObject
                        var url_image = str["image"] as?  String ?? ""
                        each_list["image"] = url_image.replacingOccurrences(of: " ", with: "%20") as AnyObject
                        each_list["date"] =  str["date"] as AnyObject
                        each_list["city"] =  str["city"] as AnyObject
                        each_list["category"] =  str["category"] as AnyObject
                        each_list["user"] =  str["user"] as AnyObject
                        self.productListArray.append(each_list)
                        
                        
                        print(self.productListArray)
                    }
                    self.productTableView.reloadData()
                }
            }
        }
    }
}
