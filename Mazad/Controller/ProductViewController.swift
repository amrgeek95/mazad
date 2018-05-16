//
//  ProductViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/29/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MBProgressHUD
import Toast
import NYTPhotoViewer
import Lightbox

class ProductViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource ,LightboxControllerDismissalDelegate{
    var productData = [String:Any]()
    var imageData = [Dictionary<String,Any>]()
    var product_id = ""
    var commentData = [Dictionary<String,Any>]()
    var imagelightbox = [LightboxImage]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return imageData.count
        }
        else if section == 4 {
            return commentData.count
        }
        else{
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as? informationTableViewCell
            cell?.userLabel.text = productData["user"] as? String ?? ""
            cell?.cityLabel.text = productData["city"] as? String ?? ""
            cell?.dateLabel.text = productData["created"] as? String ?? ""
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell!
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as? titleTableViewCell
            cell?.titleLabel.text = productData["name"] as? String ?? ""
            cell?.bodyLabel.text = productData["body"] as? String ?? ""
            cell?.mainContainerView.borderRound(border: 0.2, corner: 10)
            cell?.mainContainerView.dropShadow()
            
            cell?.containerView.borderRound(border: 0.2, corner: 15)
            cell?.containerView.dropShadow(color: UIColor.lightGray, opacity: 0.5, radius: 5)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell!
        }
        else if indexPath.section ==  2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as? imageTableViewCell
            print(imageData[indexPath.row]["image"] as! String)
            
            cell?.img.sd_setImage(with: URL(string: imageData[indexPath.row]["image"] as! String), placeholderImage: UIImage(named: "placeholder"))
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            if imageData[indexPath.row]["image"] as! String != "" {
                if imagelightbox.count != imageData.count {
                    imagelightbox.append(LightboxImage(imageURL: URL(string: imageData[indexPath.row]["image"] as! String)!))
                    let tapImg = UITapGestureRecognizer(target:self,action: #selector(self.tapImg(_:)))
                    cell?.img.addGestureRecognizer(tapImg)
                    cell?.img.isUserInteractionEnabled = true
                }
            }
           
            
            cell?.containerView.borderRound(border: 1, corner: 40)
            
            cell?.img.layer.cornerRadius = 30
            
            cell?.img.layer.masksToBounds = true
            cell?.img.layer.borderWidth = 0.5
            cell?.img.layer.borderColor = UIColor.white.cgColor
            cell?.img.layer.cornerRadius = 20
            cell?.img.contentMode = .scaleAspectFill
           
            
            return cell!
        }
        else if indexPath.section ==  4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as? commentTableViewCell
            
            cell?.userLabel.text = commentData[indexPath.row]["user"] as? String ?? ""
            cell?.commentLabel.text = commentData[indexPath.row]["comment"] as? String ?? ""
            return cell!
        }
        else if indexPath.section ==  5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCommentCell") as? addCommentTableViewCell
            cell?.addBtn.borderRoundradius(radius: 10)
            cell?.addBtn.btndropShadow()
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.parent = self
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as? contactTableViewCell
            cell?.phoneLabel.text = productData["mobile"] as? String ?? ""
            cell?.messageLabel.text = "مراسلة"
            cell?.topView.borderRound(border: 0.2, corner: 15)
            cell?.topView.dropShadow(color: UIColor.lightGray, opacity: 0.5, radius: 5)
            print(productData["favourite"])
            cell?.index = indexPath.row
            if productData["favourite"] as? Bool == true {
                cell?.heartImg.image = UIImage(named:"heart_icon")
                cell?.favourite = true
            }else{
                cell?.heartImg.image = UIImage(named:"heart_product")
                cell?.favourite = false
            }
            cell?.heartImg.isUserInteractionEnabled = true
            
            cell?.bottomView.borderRound(border: 0.2, corner: 15)
            cell?.bottomView.dropShadow(color: UIColor.lightGray, opacity: 0.5, radius: 5)
            
            cell?.messageLabel.isUserInteractionEnabled = true
            cell?.messageImg.isUserInteractionEnabled = true
            if checkUserData(){
                if userData["id"] as? String  == productData["user_id"] as? String {
                    cell?.messageLabel.isEnabled = false
                    cell?.messageImg.isUserInteractionEnabled = false
                }
            }
           
           
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.parent = self
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 75
        } else if indexPath.section == 1 {
            return UITableViewAutomaticDimension
        }
        else if indexPath.section ==  2 {
            return self.view.bounds.width
        }
        else if indexPath.section ==  4 {
           return UITableViewAutomaticDimension
        }
        else if indexPath.section ==  5 {
            return 134
        }
        else {
            return 140
        }
    }
    @IBOutlet weak var productTableView: UITableView!
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        self.navigationItem.leftBarButtonItem?.width = 100
        self.productTableView.reloadData()
    }
    func tapImg(_ sender:UITapGestureRecognizer){
        let controller = LightboxController(images: imagelightbox)
        
      //  controller.dynamicBackground = true
        
       LightboxConfig.CloseButton.text = "اغلاق"
        present(controller, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
       
        self.productTableView.separatorStyle = .none
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 0
       
    }
    override func viewWillAppear(_ animated: Bool) {
        get_product()
       
        self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceRightToLeft
        self.navigationItem.title = ""
        self.navigationItem.leftBarButtonItem?.customView?.frame = CGRect(x: 0, y: 0, width: 100, height: (self.navigationController?.navigationBar.bounds.height)!)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceLeftToRight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get_product (){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String: Any]()
        parameters["token"] = token
        parameters["id"] = product_id
        if checkUserData() {
             parameters["user_id"] = userData["id"]
        }
        print(parameters)
        let cart_url = base_url + "get_product"
        Alamofire.request(cart_url, method: .post, parameters: parameters).responseJSON{
            (response) in
            print(response)
            MBProgressHUD.hide(for: self.view, animated: true)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                        if let product_data = results["product"] as? [String:AnyObject] {
                            print(product_data)
                            self.productData = product_data
                            self.productData["favourite"]  = results["favourite"] as? Bool
                            self.imageData.removeAll()
                            for str in (product_data["images"] as? NSArray)! {
                                print(str)
                                var each_list = [String:AnyObject]()
                                var url_image = str as?  String ?? ""
                                if url_image != ""{
                                    
                                    var base_url  = results["base_url"] as?  String ?? ""
                                    url_image = "\(base_url)\(str)"
                                    print(url_image)
                                    
                                }else{
                                   url_image  = ""
                                }
                               
                                each_list["image"] = url_image.replacingOccurrences(of: " ", with: "%20") as AnyObject
                                self.imageData.append(each_list)
                                
                            }
                            if let commentsArray = results["comments"] as? [[String:AnyObject]] {
                                for comment:[String:AnyObject] in commentsArray {
                                    var each_list = [String:AnyObject]()
                                    each_list["comment"] = comment["name"] as? AnyObject
                                    each_list["user"] = comment["user"] as? AnyObject
                                    self.commentData.append(each_list)
                                }
                            }
                            
                            self.productTableView.reloadData()
                        }
                    }
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
extension ProductViewController: NYTPhotosViewControllerDelegate {
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, handleActionButtonTappedFor photo: NYTPhoto) -> Bool {
        guard UIDevice.current.userInterfaceIdiom == .pad, let photoImage = photo.image else {
            return false
        }
        
        let shareActivityViewController = UIActivityViewController(activityItems: [photoImage], applicationActivities: nil)
        shareActivityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, items: [Any]?, error: Error?) in
            if completed {
                photosViewController.delegate?.photosViewController!(photosViewController, actionCompletedWithActivityType: activityType?.rawValue)
            }
        }
        
        shareActivityViewController.popoverPresentationController?.barButtonItem = photosViewController.rightBarButtonItem
        photosViewController.present(shareActivityViewController, animated: true, completion: nil)
        
        return true
    }
    
    
}
