//
//  listNewsViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/25/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Toast

class listNewsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var newsTableView: UITableView!
    var newsList = [Dictionary<String,Any>]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as? newsTableViewCell
        cell?.dateLabel.text = newsList[indexPath.row]["data"] as? String ?? ""
        cell?.titleBtn.setTitle(newsList[indexPath.row]["name"] as? String ?? "", for: .normal)
        cell?.categoryLabel.text = newsList[indexPath.row]["category"] as? String ?? ""
        
        cell?.img.sd_setImage(with: URL(string: newsList[indexPath.row]["image"] as! String), placeholderImage: UIImage(named: "car_icon"))
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showNews = self.storyboard?.instantiateViewController(withIdentifier: "newsView") as? newsViewController
        showNews?.news_id = newsList[indexPath.row]["id"] as! String
        print(newsList[indexPath.row]["id"] as! String)
     // self.performSegue(withIdentifier: "showNewsView", sender: nil)
        //  self.present(showNews!, animated: true, completion: nil)
        self.navigationController?.pushViewController(showNews!, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "#394044")
        let imageViewBar = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 35))
        imageViewBar.contentMode = .scaleAspectFit
        let imagebar = UIImage(named: "logo")
        imageViewBar.image = imagebar
        
        navigationItem.titleView = imageViewBar
        get_news()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func get_news(){
        self.newsList.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var parameters = [String:AnyObject]()
        
        var url = base_url + "get_news"
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            (response) in
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
                if  let result = results["news"] as? [[String:AnyObject]] {
                    print(result)
                     MBProgressHUD.hide(for: self.view,animated:true)
                    for str:[String:AnyObject] in result {
                        print(str)
                        
                        var each_list = [String:AnyObject]()
                        
                        each_list["name"] =  str["name"]! as AnyObject
                        each_list["id"] =  str["id"] as AnyObject
                        var url_image = str["image"] as?  String ?? ""
                        each_list["image"] = url_image.replacingOccurrences(of: " ", with: "%20") as AnyObject
                        each_list["date"] =  str["created"] as AnyObject
                        each_list["category"] =  str["category"] as AnyObject
                        self.newsList.append(each_list)
                        
                        
                        print(self.newsList)
                    }
                    self.newsTableView.reloadData()
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