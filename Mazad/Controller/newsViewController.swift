//
//  newsViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/25/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Lightbox
class newsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var newsData = [String:Any]()
    var imageData = [Dictionary<String,Any>]()
    var news_id = ""
    var like = ""
    var dislike = ""
    var imagelightbox = [LightboxImage]()
    
    @IBOutlet weak var newsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        var like = ""
        var dislike = ""
        self.newsTableView.separatorStyle = .none
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 0
        
        newsTableView.rowHeight = UITableViewAutomaticDimension
         self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceRightToLeft
        get_news()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceLeftToRight
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return imageData.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
              return UITableViewAutomaticDimension
        } else if indexPath.section == 1 {
            return UITableViewAutomaticDimension
        }
        else if indexPath.section ==  2 {
            return self.view.bounds.width
        }
        
        else {
            return 70
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
          let cell = tableView.dequeueReusableCell(withIdentifier: "newsTitleCell") as? newsTitleTableViewCell
            print(newsData)
            
            cell?.titleLabel.text = newsData["name"] as? String ?? ""
            return cell!
        } else  if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bodyNewsCell") as? bodyNewsTableViewCell
           cell?.dataLabel.text = newsData["date"] as? String ?? ""
            cell?.bodyLabel.text = newsData["body"] as? String ?? ""
             cell?.containerView.borderRound(border: 0.2, corner: 15)
            return cell!
         } else  if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as? imageTableViewCell
            cell?.img.sd_setImage(with: URL(string: imageData[indexPath.row]["image"] as! String), placeholderImage: UIImage(named: "placeholder"))
            if imagelightbox.count != imageData.count {
                imagelightbox.append(LightboxImage(imageURL: URL(string: imageData[indexPath.row]["image"] as! String)!))
            }
            let tapImg = UITapGestureRecognizer(target:self,action: #selector(self.tapImg(_:)))
            cell?.img.addGestureRecognizer(tapImg)
            cell?.img.isUserInteractionEnabled = true
           
            cell?.containerView.borderRound(border: 1, corner: 40)
            
            cell?.img.layer.cornerRadius = 30
            
            cell?.img.layer.masksToBounds = true
            cell?.img.layer.borderWidth = 0.5
            cell?.img.layer.borderColor = UIColor.white.cgColor
            cell?.img.layer.cornerRadius = 20
            cell?.img.contentMode = .scaleAspectFill
            return cell!
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "likeCell") as? likeTableViewCell
            cell?.parent = self
            print(self.newsData["like"])
            print(self.newsData["dislike"])
            
           cell?.likeLabel.text = "\(self.newsData["like"] as? Int ?? 0)"
            cell?.dislikeLabel.text = "\(self.newsData["dislike"] as? Int ?? 0)"
            cell?.containerView.dropShadow(color: UIColor.lightGray, opacity: 1, radius: 10)
            return cell!
        }
    }
    func tapImg(_ sender:UITapGestureRecognizer){
        let controller = LightboxController(images: imagelightbox)
        
        controller.dynamicBackground = true
          LightboxConfig.CloseButton.text = "اغلاق"
        
        present(controller, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addLike( sender:UIButton){
        
    }
    func addDisLike(sender:UIButton){
        
    }
    func get_news (){
        var parameters = [String: Any]()
        
        parameters["token"] = token
        
        parameters["id"] = news_id
        print(parameters)
        let cart_url = base_url + "show_news"
        Alamofire.request(cart_url, method: .post, parameters: parameters).responseJSON{
            (response) in
            print(response)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    if success == true {
                        if let news_data = results["news"] as? [String:AnyObject] {
                            print(news_data)
                            self.newsData = news_data
                            let title = news_data["name"] as? String ?? ""
                           
                            // Access substring from range.
                            var result = title
                            if title.characters.count > 15 {
                                let r = title.index(title.startIndex, offsetBy: 0)..<title.index(title.startIndex, offsetBy: 15)
                                
                                 result = title[r]
                               result = title[r] + " ... " 
                            }
                           print(result)
                            self.navigationItem.title = "\(result) " as String
                            print(results["like"])
                            print(results["dislike"])
                            self.newsData["like"] = results["like"] as? Int ?? 0
                            self.newsData["dislike"] = results["dislike"] as? Int ?? 0
                            self.imageData.removeAll()
                            for str in (self.newsData["images"] as? NSArray)! {
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
                            self.newsTableView.reloadData()
                        }else{
                            
                        }
                    }else{
                        
                    }
                    
                } else{
                    
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
