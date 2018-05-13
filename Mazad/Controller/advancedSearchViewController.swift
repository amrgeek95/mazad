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

class advancedSearchViewController: SuperParentViewController,UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var advancedTableView: UITableView!
    var categoryArray = [Dictionary<String,AnyObject>]()
    var subCategoryArray = [[String]]()
    var subCategoryIdArray = [[String]]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(categoryArray[collectionView.tag]["sub_count"])
        
        return categoryArray[collectionView.tag]["sub_count"] as? Int ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let yourWidth = CGFloat((collectionView.frame.size.width / 2) - 10 )
            let yourHeight = 40
            
            return CGSize(width: yourWidth, height: yourWidth)
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advancedCollection", for: indexPath) as? advancedCollectionViewCell
        if !subCategoryArray[collectionView.tag].isEmpty {
            cell?.categoryDrop.anchorView = cell?.categoryBtn // UIView or UIBarButtonItem
            cell?.categoryDrop.dataSource = self.subCategoryArray[collectionView.tag]
            cell?.categoryBtn.setTitle(self.subCategoryArray[collectionView.tag].first as? String ?? "", for: .normal)
            cell?.sub_id = self.subCategoryIdArray[collectionView.tag].first!
            cell?.categoryDrop.width = cell?.categoryBtn.frame.size.width
            cell?.categoryDrop.direction = .any
            cell?.categoryDrop.bottomOffset = CGPoint(x: 0, y:(cell?.categoryDrop.anchorView?.plainView.bounds.height)!)
            cell?.categoryDrop.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                cell?.categoryBtn.setTitle("+\(self.subCategoryArray[collectionView.tag][index])", for: .normal)
                self.view.layoutIfNeeded()
                cell?.sub_id = "\(self.subCategoryIdArray[collectionView.tag][index])"
                
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "advancedCell") as? advancedCellTableViewCell
        cell?.categoryLabel.text = categoryArray[indexPath.row]["name"] as? String ?? ""
        cell?.advancedCollectionView?.delegate = self
        cell?.advancedCollectionView?.dataSource = self
        cell?.advancedCollectionView?.tag = indexPath.row
        cell?.advancedCollectionView?.reloadData()
        self.advancedTableView.setNeedsLayout()
        self.advancedTableView.layoutIfNeeded()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        cell?.advancedCollectionView?.collectionViewLayout = layout
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCategory()
        
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
                                    print("subcategory\(subcategory)")
                                    
                                }
                                self.subCategoryArray.append(each_sub_name)
                                self.subCategoryIdArray.append(each_sub_id)
                                print("subCategoryArray\(self.categoryArray)")
                                print("catesubCategoryIdArraygoryArray\(self.categoryArray)")
                                print("subCategoryArray\(self.subCategoryArray)")
                                print("subCategoryIdArray\(self.subCategoryIdArray)")
                                
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
