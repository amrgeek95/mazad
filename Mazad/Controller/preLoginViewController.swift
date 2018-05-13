//
//  preLoginViewController.swift
//  Mazad
//
//  Created by amr sobhy on 4/26/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

class preLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceLeftToRight
        self.tabBarController?.tabBar.isHidden = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#394044")
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.plainView.semanticContentAttribute = .forceRightToLeft

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
