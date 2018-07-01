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
class addProductViewController: SuperParentViewController ,UITableViewDataSource,UITableViewDelegate ,UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
     var years = [String]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            let yourWidth = CGFloat((collectionView.frame.size.width / 3) - 10 )
            let yourHeight = yourWidth
            
            return CGSize(width: yourWidth, height: yourWidth)
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionCell", for: indexPath as IndexPath) as! imageCollectionViewCell
        cell.image.sd_setImage(with: URL(string: image_url + image[indexPath.row] as? String ?? ""), placeholderImage: UIImage(named: "placeholder"))
        return cell
    }
    
    
    
    var image_url = "http://mazad-sa.net/mazad/prod_img/"
    var option_array =  ["جدة","المدينة","الرياض","مكة","سدير"]
     var option_id =  ["0","1","2","3","4"]
    var sub_id = [String]()
    var sub_array = [String]()
    var childrens_array = [String: [String]]()
     var childrens_id = [String: [String]]()
    var city_selected = ""
    var category_id = ""
    var image = [String]()
    
    
    @IBOutlet weak var childrenBtn: UIButton!
    @IBOutlet weak var childrenTop: NSLayoutConstraint!
    var category_name = ""
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newProductCell") as? newProductTableViewCell
        
        
        //check if the category is سيارات
        
        if category_name.contains("سيارات") {
            
            cell?.modelTop.constant = 7
            cell?.modelBtn.isHidden = false
            cell?.modelDropDown.anchorView = cell?.modelBtn // UIView or UIBarButtonItem
            cell?.modelDropDown.dataSource = self.years
            cell?.modelBtn.setTitle(self.years.first as? String ?? "", for: .normal)
            cell?.model_id = self.years.first!
            cell?.modelDropDown.width = cell?.modelBtn.frame.size.width
            cell?.modelDropDown.direction = .any
            cell?.modelDropDown.bottomOffset = CGPoint(x: 0, y:(cell?.modelDropDown.anchorView?.plainView.bounds.height)!)
            cell?.modelDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                cell?.modelBtn.setTitle("+\(self.years[index])", for: .normal)
                self.view.layoutIfNeeded()
                cell?.child_id = "\(self.years[index])"
                //append child dropdown
                print("\(self.years[index])")
                
            }
        }
        else{
            cell?.modelBtn.isHidden = true
            cell?.modelTop.constant = -20
            //  self.productTableView.reloadData()
            
        }
        //end
        
        if !option_array.isEmpty {
            cell?.imageCollectionView.delegate = self
            cell?.imageCollectionView.dataSource = self
            cell?.imageCollectionView.tag = indexPath.row
            
            cell?.imageCollectionView.reloadData()
            self.productTableView.setNeedsLayout()
            self.productTableView.layoutIfNeeded()
            cell?.selectionStyle = .none
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            
            layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            
            cell?.imageCollectionView!.collectionViewLayout = layout
            
            cell?.childrenTop.constant = -20
            cell?.childrenBtn.isHidden = true
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
            cell?.dropDown2.anchorView = cell?.subBtn // UIView or UIBarButtonItem
            cell?.dropDown2.dataSource = self.sub_array
            cell?.subBtn.setTitle(self.sub_array.first as? String ?? "", for: .normal)
            cell?.sub_id = self.sub_id.first!
            cell?.dropDown2.width = cell?.subBtn.frame.size.width
            cell?.dropDown2.direction = .any
            cell?.dropDown2.bottomOffset = CGPoint(x: 0, y:(cell?.dropDown2.anchorView?.plainView.bounds.height)!)
            cell?.dropDown2.selectionAction = { [unowned self] (index_sub: Int, item: String) in
                print("Selected item: \(item) at index: \(index_sub)")
                cell?.subBtn.setTitle("+\(self.sub_array[index_sub])", for: .normal)
                self.view.layoutIfNeeded()
                print("\(self.sub_id[index_sub])")
                
                cell?.sub_id = "\(self.sub_id[index_sub])"
               
                // check if subcategory has another sub category
                if let children_exist = self.childrens_array[self.sub_id[index_sub]] as? [String]{
                    if !(self.childrens_array[self.sub_id[index_sub]]?.isEmpty)!{
                        cell?.childrenTop.constant = 7
                        cell?.childrenBtn.isHidden = false
                        cell?.dropDown3.anchorView = cell?.childrenBtn // UIView or UIBarButtonItem
                        cell?.dropDown3.dataSource = self.childrens_array[self.sub_id[index_sub]]!
                        cell?.childrenBtn.setTitle(self.childrens_array[self.sub_id[index_sub]]?.first as? String ?? "", for: .normal)
                        cell?.child_id = (self.childrens_id[self.sub_id[index_sub]]?.first!)!
                        cell?.dropDown3.width = cell?.childrenBtn.frame.size.width
                        cell?.dropDown3.direction = .any
                        cell?.dropDown3.bottomOffset = CGPoint(x: 0, y:(cell?.dropDown3.anchorView?.plainView.bounds.height)!)
                        cell?.dropDown3.selectionAction = { [unowned self] (index: Int, item: String) in
                            print("Selected item: \(item) at index: \(index)")
                            cell?.childrenBtn.setTitle("+\(self.childrens_array[self.sub_id[index_sub]]![index])", for: .normal)
                            self.view.layoutIfNeeded()
                            cell?.child_id = "\(self.childrens_id[self.sub_id[index_sub]]![index])"
                            //append child dropdown
                                print("\(self.childrens_id[self.sub_id[index_sub]]![index])")
                            
                        }
                    }
                }else{
                    cell?.childrenBtn.isHidden = true
                    cell?.childrenTop.constant = -20
                  //  self.productTableView.reloadData()
                }
                //append child dropdown
                
            }
        }
       
        
        let myColor = UIColor.clear
      
        cell?.phoneText.setBottomBorder()
        cell?.titleText.setBottomBorder()
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
        return 820
    }
    @IBOutlet weak var productTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.productTableView.separatorStyle = .none
     
        self.productTableView.backgroundView?.backgroundColor = UIColor.clear
        self.get_cities()
        self.get_sub()
        print(category_id)
        var dictionary = [String: [String]]()
        
        
        dictionary["3"] = ["1","2","3"]
        for i in (1970..<2019).reversed() {
            years.append("\(i)")
        }
        
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
       self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceRightToLeft
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceLeftToRight
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
             MBProgressHUD.hide(for: self.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
               
                if  let result = results["subcategories"] as? [[String:AnyObject]] {
                    
                    for str:[String:AnyObject] in result {
                        print(str)
                        self.sub_array.append(str["name"] as? String ?? "")
                        self.sub_id.append(str["id"] as? String ?? "")
                        if let childrens = str["children"] as? [[String:AnyObject]] {
                            
                            var child_id = [String]()
                            var child_name = [String]()
                            for children:[String:AnyObject] in childrens {
                                child_name.append(children["name"] as? String ?? "")
                                child_id.append(children["id"] as? String ?? "")
                            }
                            self.childrens_array[str["id"] as? String ?? "0"] = child_name
                             self.childrens_id[str["id"] as? String ?? "0"] = child_id
                            print(self.childrens_array)
                            print(self.childrens_id)
                            print("children")
                        }
                        
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

