//
//  aboutViewController.swift
//  Mazad
//
//  Created by amr sobhy on 5/16/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class aboutViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var aboutTableView: UITableView!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell")
            return cell!
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell2")
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutTextCell") as? aboutTextTableViewCell
            cell?.parent = self
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 240
        } else if indexPath.row == 1{
           return 370
        } else {
            
            return 420
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "عمولة وانظمة مزاد"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
