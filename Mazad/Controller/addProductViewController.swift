//
//  addProductViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/25/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import DLRadioButton
import Alamofire
import MBProgressHUD
import Toast
class addProductViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    
    var option_array =  ["جدة","المدينة","الرياض","مكة","سدير"]
     var option_id =  ["0","1","2","3","4"]
    var sub_id = [String]()
    var sub_array = [String]()
    var city_selected = ""
    var category_id = ""
    var category_name = ""
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newProductCell") as? newProductTableViewCell
        if !option_array.isEmpty {
            cell?.dropDown.anchorView = cell?.cityBtn // UIView or UIBarButtonItem
            cell?.dropDown.dataSource = self.option_array
            cell?.cityBtn.setTitle(self.option_array.first as? String ?? "", for: .normal)
            cell?.city_id = self.option_id.first!
            cell?.dropDown.width = cell?.cityBtn.frame.size.width
            cell?.dropDown.direction = .any
            cell?.dropDown.bottomOffset = CGPoint(x: 0, y:(cell?.dropDown.anchorView?.plainView.bounds.height)!)
            cell?.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                cell?.cityBtn.setTitle("+\(self.option_array[index])", for: .normal)
                self.view.layoutIfNeeded()
                self.city_selected = "\(self.option_id[index])"
                cell?.city_id = "\(self.option_id[index])"
                
            }
        }
        if !sub_array.isEmpty {
            cell?.dropDown2.anchorView = cell?.cityBtn // UIView or UIBarButtonItem
            cell?.dropDown2.dataSource = self.sub_array
            cell?.subBtn.setTitle(self.sub_array.first as? String ?? "", for: .normal)
            cell?.sub_id = self.sub_id.first!
            cell?.dropDown2.width = cell?.subBtn.frame.size.width
            cell?.dropDown2.direction = .any
            cell?.dropDown2.bottomOffset = CGPoint(x: 0, y:(cell?.dropDown2.anchorView?.plainView.bounds.height)!)
            cell?.dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                cell?.subBtn.setTitle("+\(self.sub_array[index])", for: .normal)
                self.view.layoutIfNeeded()
                cell?.sub_id = "\(self.sub_id[index])"
                
            }
        }
       
        
        let myColor = UIColor.clear
      
        cell?.phoneText.setBottomBorder()
        cell?.titleText.setBottomBorder()
        cell?.bodyText.borderRound(border: 0.8, corner: 10)
        cell?.submitBtn.borderRoundradius(radius: 10)
        cell?.parent = self
        cell?.category_id = category_id
        self.productTableView.setNeedsLayout()
        self.productTableView.layoutIfNeeded()
        cell?.categoryBtn.setTitle(category_name, for: .normal)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    @IBOutlet weak var productTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.productTableView.separatorStyle = .none
     
        self.productTableView.backgroundView?.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = " اضافة اعلان"
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#394044")
        self.get_cities()
        self.get_sub()
        print(category_id)
    }
    func get_cities(){
        self.option_id.removeAll()
        self.option_array.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:AnyObject]()
        
        var url = base_url + "cities"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            (response) in
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
                MBProgressHUD.hide(for: self.view,animated:true)
                if  let result = results["cities"] as? [[String:String]] {
                    print(result)
                    for str:[String:String] in result {
                        print(str)
                        self.option_array.append(str["name"] as? String ?? "")
                        self.option_id.append(str["id"] as? String ?? "")
                    }
                    self.productTableView.reloadData()
                }
            }
        }
    }
    func get_sub(){
        self.sub_id.removeAll()
        self.sub_array.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:AnyObject]()
        parameters["category_id"] = category_id as AnyObject
        var url = base_url + "get_subcategory"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            (response) in
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
                MBProgressHUD.hide(for: self.view,animated:true)
                if  let result = results["subcategories"] as? [[String:String]] {
                    
                    for str:[String:String] in result {
                        print(str)
                        self.sub_array.append(str["name"] as? String ?? "")
                        self.sub_id.append(str["id"] as? String ?? "")
                    }
                    self.productTableView.reloadData()
                }
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

