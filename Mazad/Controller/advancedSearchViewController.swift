//
//  advancedSearchViewController.swift
//  Mazad
//
//  Created by amr sobhy on 5/13/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import Toast
import MBProgressHUD
import SideMenuController
//150 120
class advancedSearchViewController: SuperParentViewController,UITableViewDataSource, UITableViewDelegate ,SideMenuControllerDelegate{
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        
    }
    
    @IBOutlet weak var advancedTableView: UITableView!
    var categoryArray = [Dictionary<String,AnyObject>]()
    var subCategoryArray = [[String]]()
    var subCategoryIdArray = [[String]]()
    var childrens_array = [String: [String]]()
    var childrens_id = [String: [String]]()
    var cell_height = [CGFloat]()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(cell_height[indexPath.row])
        return cell_height[indexPath.row]
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "advancedCell") as? advancedCellTableViewCell
        cell?.childBtn.isHidden = true
        cell?.childrenTop.constant = -25
        cell?.containerView.borderRound(border: 0.2, corner: 10)
       cell?.parent = self
        cell?.categoryLabel.text = categoryArray[indexPath.row]["name"] as? String ?? ""
        if !subCategoryArray[indexPath.row].isEmpty {
            cell?.dropDown.anchorView = cell?.subBtn // UIView or UIBarButtonItem
            cell?.dropDown.dataSource = self.subCategoryArray[indexPath.row]
            cell?.subBtn.setTitle(self.subCategoryArray[indexPath.row].first as? String ?? "", for: .normal)
            cell?.sub_id = self.subCategoryIdArray[indexPath.row].first!
            cell?.dropDown.width = cell?.subBtn.frame.size.width
            cell?.dropDown.direction = .any
            cell?.dropDown.bottomOffset = CGPoint(x: 0, y:(cell?.dropDown.anchorView?.plainView.bounds.height)!)
            cell?.dropDown.selectionAction = { [unowned self] (index_sub: Int, item: String) in
                print("Selected item: \(item) at index: \(index_sub)")
                cell?.subBtn.setTitle("+\(self.subCategoryArray[indexPath.row][index_sub])", for: .normal)
                self.view.layoutIfNeeded()
                cell?.sub_id = "\(self.subCategoryIdArray[indexPath.row][index_sub])"
                cell?.childBtn.isHidden = true
                cell?.childrenTop.constant = -25
                
                if let children_exist = self.childrens_array[self.subCategoryIdArray[indexPath.row][index_sub]] as? [String]{
                    if !(self.childrens_array[self.subCategoryIdArray[indexPath.row][index_sub]]?.isEmpty)!{
                        cell?.childrenTop.constant = 7
                        cell?.childBtn.isHidden = false
                        cell?.dropDown2.anchorView = cell?.childBtn // UIView or UIBarButtonItem
                        cell?.dropDown2.dataSource = self.childrens_array[self.subCategoryIdArray[indexPath.row][index_sub]]!
                        cell?.childBtn.setTitle(self.childrens_array[self.subCategoryIdArray[indexPath.row][index_sub]]?.first as? String ?? "", for: .normal)
                        cell?.child_id = (self.childrens_id[self.subCategoryIdArray[indexPath.row][index_sub]]?.first!)!
                        cell?.dropDown2.width = cell?.childBtn.frame.size.width
                        cell?.dropDown2.direction = .any
                        cell?.dropDown2.bottomOffset = CGPoint(x: 0, y:(cell?.dropDown2.anchorView?.plainView.bounds.height)!)
                        cell?.dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
                            print("Selected item: \(item) at index: \(index)")
                            cell?.childBtn.setTitle("+\(self.childrens_array[self.subCategoryIdArray[indexPath.row][index_sub]]![index])", for: .normal)
                            self.view.layoutIfNeeded()
                            cell?.child_id = "\(self.childrens_id[self.subCategoryIdArray[indexPath.row][index_sub]]![index])"
                            //append child dropdown
                        }
                    }
                }else{
                   
                    //  self.productTableView.reloadData()
                }
                //append child dropdown
                
            }
        }
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCategory()
        self.navigationItem.title = "بحث متخصص"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getAllCategory(){
        let parameters = [String:AnyObject]()
        var all_url = base_url + "all_category"
        Alamofire.request(all_url, method: .post ,parameters:parameters).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                print(value)
                print("value")
                
                if let results = response.result.value as? Dictionary<String,Any>{
                    print(results)
                    
                    if let categ = results["categories"] as? [[String:AnyObject]]{
                        for categories:[String:AnyObject] in categ {
                            var each_cateogry = ["sub_count":categories["sub_count"],"name":categories["name"],"id":categories["id"]]
                            print("eachcategory\(each_cateogry)")
                            print("categories\(categories)")
                            self.categoryArray.append(each_cateogry as [String : AnyObject])
                            print("categoryArray\(self.categoryArray)")
                            
                            if let subcategories = categories["subcategories"] as? [[String:AnyObject]]{
                                var each_sub_name =  [String]()
                                var each_sub_id =  [String]()
                                for subcategory:[String:AnyObject] in subcategories {
                                    each_sub_name.append(subcategory["name"] as? String ?? "")
                                    each_sub_id.append(subcategory["id"] as? String ?? "")
                                    if let childrens = subcategory["children"] as? [[String:AnyObject]] {
                                        
                                        var child_id = [String]()
                                        var child_name = [String]()
                                        for children:[String:AnyObject] in childrens {
                                            child_name.append(children["name"] as? String ?? "")
                                            child_id.append(children["id"] as? String ?? "")
                                        }
                                        self.childrens_array[subcategory["id"] as? String ?? "0"] = child_name
                                        self.childrens_id[subcategory["id"] as? String ?? "0"] = child_id
                                        print(self.childrens_array)
                                        print(self.childrens_id)
                                        print("children")
                                        if childrens.isEmpty {
                                             self.cell_height.append(165)
                                        } else {
                                           self.cell_height.append(195)
                                        }
                                       
                                    }
                                }
                                self.subCategoryArray.append(each_sub_name)
                                self.subCategoryIdArray.append(each_sub_id)
                                print("subCategoryArray\(self.categoryArray)")
                                print("cateself.subCategoryIdArraygoryArray\(self.categoryArray)")
                                print("subCategoryArray\(self.subCategoryArray)")
                                print("self.subCategoryIdArray\(self.subCategoryIdArray)")
                                
                            }else{
                                self.cell_height.append(50)
                            }
                            
                        }
                    }
                   self.advancedTableView.reloadData()
                }
                
            case .failure(let error):
                break;
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
