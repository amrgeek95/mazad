//
//  categoriesTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 4/26/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import UserNotifications
class categoriesTableViewCell: UITableViewCell ,UNUserNotificationCenterDelegate {
 
    
    @IBOutlet weak var notification: UISwitch!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.borderRound(border: 0.5, corner: 10)
        containerView.dropShadow()
    }

    @IBAction func notificationAction(_ sender: Any) {
        if notification.isOn {
            print("true")
            if #available(iOS 10.0, *) {
                
                // SETUP FOR NOTIFICATION FOR iOS >= 10.0
                let center  = UNUserNotificationCenter.current()
                center.delegate = self
                center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                    if error == nil{
                        DispatchQueue.main.async(execute: {
                            UIApplication.shared.registerForRemoteNotifications()
                        })
                    }
                }
                
            } else {
                
                // SETUP FOR NOTIFICATION FOR iOS < 10.0
                
                let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                
                // This is an asynchronous method to retrieve a Device Token
                // Callbacks are in AppDelegate.swift
                // Success = didRegisterForRemoteNotificationsWithDeviceToken
                // Fail = didFailToRegisterForRemoteNotificationsWithError
                UIApplication.shared.registerForRemoteNotifications()
            }
        }else{
            UIApplication.shared.unregisterForRemoteNotifications()

            print("false")
        }
       
    }
    @IBOutlet weak var categoryName: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
