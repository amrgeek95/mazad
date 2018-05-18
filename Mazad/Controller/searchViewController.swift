//
//  searchViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/27/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast

class searchViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate{
    var searchArray = [String]()
    var recentSearch = true
    var old = false
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recentSearch ==  true {
          return  searchArray.count
        }else{
         
            return productListArray.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if recentSearch ==  true {
            mySearchtext = searchArray[indexPath.row]
            old = true
            filter_products()
        }else{
            let showProduct = self.storyboard?.instantiateViewController(withIdentifier: "productView") as? ProductViewController
            showProduct?.product_id = productListArray[indexPath.row]["id"] as! String
            self.navigationController?.pushViewController(showProduct!, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recentSearch  == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! searchTableViewCell
            cell.searchLabel.text = searchArray[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "productTableViewCell") as? productTableViewCell
            
            cell?.cityLabel.text = productListArray[indexPath.row]["city"] as? String ?? ""
            cell?.nameLabel.text = productListArray[indexPath.row]["name"] as? String ?? ""
            cell?.userLabel.text = productListArray[indexPath.row]["user"] as? String ?? ""
            cell?.productImage.layer.cornerRadius = 10
            
            cell?.productImage.layer.masksToBounds = true
            cell?.productImage.layer.borderWidth = 3
            cell?.productImage.layer.borderColor = UIColor.lightGray.cgColor
            cell?.productImage.layer.cornerRadius = 20
            cell?.productImage.contentMode = .scaleAspectFill
            cell?.favouriteIcon.isHidden = true
            
            cell?.productImage.sd_setImage(with: URL(string: productListArray[indexPath.row]["image"] as? String ?? ""), placeholderImage: UIImage(named: "car_icon"))
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if recentSearch == true {
            
            return 50
        }else{
         
            return 125
        }
    }
    
    
    var productListArray = [Dictionary<String,Any>]()
    @IBOutlet weak var productTableView: UITableView!
    
    private var mySearchBar: UISearchBar!
    var mySearchtext = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        productListArray.removeAll()
        let nib = UINib.init(nibName: "productTableViewCell", bundle: nil)
        self.productTableView.register(nib, forCellReuseIdentifier: "productTableViewCell")
        
        self.productTableView.backgroundView?.backgroundColor = UIColor.clear
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        get_recent_search()
        self.navigationItem.title = "البحث"
        self.productListArray.removeAll()
        self.productTableView.reloadData()
        my_products = 0
        filter_category = 0
        add_product_flag = 0
        my_favourites = 0
        mySearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 70))
        mySearchBar.delegate = self
        //   lazy var mySearchBar = UISearchBar(frame: CGRect.zero)
        // hide cancel button
       // mySearchBar.showsCancelButton = true
        
        // hide bookmark button
        mySearchBar.showsBookmarkButton = false
        
        // set Default bar status.
        mySearchBar.searchBarStyle = UISearchBarStyle.default
        
        // set title
       
        
        // set placeholder
        mySearchBar.placeholder = "بحث"
        mySearchBar.setValue("إلغاء", forKey:"_cancelButtonText")
        mySearchBar.setValue("custom", forKey: "cancelButtonText")

        

        
        // change the color of cursol and cancel button.
        mySearchBar.tintColor = UIColor(hexString: "#21A6DF")
        
        // hide the search result.
        mySearchBar.showsSearchResultsButton = false
        
        // add searchBar to the view.
        mySearchBar.sizeToFit()
        navigationItem.titleView = mySearchBar
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        mySearchtext = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = nil
        mySearchBar.text = ""
        let imageViewBar = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageViewBar.contentMode = .scaleAspectFit
        let imagebar = UIImage(named: "Logoblue")
        imageViewBar.image = imagebar
        navigationItem.titleView = imageViewBar
    }
    
    // called when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mySearchtext =  mySearchBar.text!
       
        print("## search btn clicked : \(searchBar.text ?? "")")
        print(mySearchBar.text!)
        searchBar.endEditing(true)
        searchBar.text = nil
        recentSearch = false
        filter_products()
        
    }
    func get_recent_search(){
        self.searchArray.removeAll()
        var parameters = [String:AnyObject]()
        if checkUserData(){
            parameters["user_id"] = userData["id"] as AnyObject
        }
        print(parameters)
        var url = base_url + "get_search"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            (response) in
            if let results = response.result.value as? [String:AnyObject]{
                if let result_search = results["search"] as? [String] {
                    self.searchArray = result_search
                   
                    self.productTableView.reloadData()
                    
                }
            }
        }
    }
    func filter_products(){
        recentSearch = false
        self.productListArray.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:AnyObject]()
        parameters["search"] = mySearchtext as AnyObject
        if checkUserData(){
            parameters["user_id"] = userData["id"] as AnyObject
            if old == true {
            parameters["old"] = true as AnyObject
                old = false
            }
        }
        print(parameters)
        var url = base_url + "get_products"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            (response) in
            MBProgressHUD.hide(for: self.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
                
                if  let result = results["products"] as? [[String:AnyObject]] {
                    print(result)
                    if results["status"] as? Bool == true {
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
                    }else {
                        Mazad.toastView(messsage: "عفوا , لا يوجد اعلانات بهذا الاسم", view: self.view)
                    }
                   
                    self.productTableView.reloadData()
                }else {
                    Mazad.toastView(messsage: "عفوا , لا يوجد اعلانات بهذا الاسم", view: self.view)
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
