//
//  categoriesViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/25/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast

class categoriesViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    
    
    @IBOutlet weak var categoriesTableView: UITableView!
    var categoriesList = [Dictionary<String,Any>]()
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesList = [["name":"cars","image":"car_icon"],
                           ["name":"camel","image":"camel_icon"],
                           ["name":"building","image":"building_icon"],
                           ["name":"phones","image":"phone_icon"
                           ]]
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationItem.title = ""
    }
    override func viewWillAppear(_ animated: Bool) {
        if add_product_flag == 1 {
        self.navigationItem.title = " اختر قسم الاعلان "
        }else{
          self.navigationItem.title = " الاقسام "
        }
      
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#394044")
        self.get_categories()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if add_product_flag == 0 {
            let initialMain = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as? mainViewController
            global_category_id = categoriesList[indexPath.row]["id"] as? String ?? ""
            //saveSegue(data: true, name:"filter_category",stingData : categoriesList[indexPath.row]["id"] as? String ?? "")
          //  self.navigationController?.pushViewController(initialMain!, animated: true)
            self.present(initialMain!, animated: true, completion: nil)
        }else{
            global_category_id = ""
            let addProduct = self.storyboard?.instantiateViewController(withIdentifier: "addProductView") as? addProductViewController
            addProduct?.category_id = categoriesList[indexPath.row]["id"] as? String ?? ""
            addProduct?.category_name = categoriesList[indexPath.row]["name"] as? String ?? ""
            
            self.navigationController?.pushViewController(addProduct!, animated: true)
        }
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  categoriesList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell") as? categoriesTableViewCell
        cell?.categoryName.setTitle( categoriesList[indexPath.row]["name"] as? String ?? "", for: .normal)
       
        cell?.img.sd_setImage(with: URL(string: categoriesList[indexPath.row]["image"] as? String ?? ""), placeholderImage: UIImage(named: "car_icon"))
        cell?.img.contentMode = .scaleAspectFit
        return cell!
    }
    func get_categories(){
        self.categoriesList.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:AnyObject]()
        
        var url = base_url + "get_category"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            (response) in
             MBProgressHUD.hide(for: self.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
               
                if  let result = results["categories"] as? [[String:String]] {
                    print(result)
                    for str:[String:String] in result {
                        print(str)
                        var each_list = [String:AnyObject]()
                        
                        each_list["name"] =  str["name"]! as AnyObject
                        each_list["id"] =  str["id"] as AnyObject
                        var url_image = str["image"] as?  String ?? ""
                        each_list["image"] = url_image.replacingOccurrences(of: " ", with: "%20") as AnyObject
                        self.categoriesList.append(each_list)
                        
                        
                        print(self.categoriesList)
                    }
                    self.categoriesTableView.reloadData()
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
