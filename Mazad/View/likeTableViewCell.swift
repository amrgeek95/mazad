//
//  likeTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 5/2/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MBProgressHUD
import Toast
class likeTableViewCell: UITableViewCell {

    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var dislikeImg: UIImageView!
    @IBOutlet weak var dislikeLabel: UILabel!
    var parent:newsViewController!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        let tapLike = UITapGestureRecognizer(target:self,action: #selector(self.addlike(_:)))
        let tapDislike = UITapGestureRecognizer(target:self,action: #selector(self.add_dislike(_:)))
        self.likeImg.tag = 1
        self.dislikeImg.tag = 0
        self.likeImg.addGestureRecognizer(tapLike)
        self.dislikeImg.addGestureRecognizer(tapDislike)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func addlike(_ sender:UITapGestureRecognizer){
        if checkUserData() {
            var parameters = [String:Any]()
            parameters["status"] = 1
            parameters["news_id"] = self.parent.news_id
            parameters["user_id"] = userData["id"]
            print(parameters)
            var add_like_url = base_url + "add_like"
            Alamofire.request(add_like_url, method: .post, parameters: parameters).responseJSON {
                (response) in
                if let results = response.result.value as? [String:AnyObject] {
                    if let status = results["status"] as? Bool {
                         self.parent.get_news()
                    }
                }
            }
            
        }
    }
    func add_dislike(_ sender:UITapGestureRecognizer){
        if checkUserData() {
            var parameters = [String:Any]()
            parameters["status"] = 0
            parameters["news_id"] = self.parent.news_id
            parameters["user_id"] = userData["id"]
            print(parameters)
            var add_like_url = base_url + "add_like"
            Alamofire.request(add_like_url, method: .post, parameters: parameters).responseJSON {
                (response) in
                if let results = response.result.value as? [String:AnyObject] {
                    if let status = results["status"] as? Bool {
                        
                        self.parent.get_news()
                        
                    }
                }
            }
            
        }
    }
    

}
