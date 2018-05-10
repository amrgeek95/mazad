//
//  SuperParentViewController.swift
//  Expand
//
//  Created by amr sobhy on 12/8/17.
//  Copyright © 2017 amr sobhy. All rights reserved.
//

import UIKit

class SuperParentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork(){
            
        }else{
            self.view.makeToast("Check Network Connection")
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UILabel.appearance().substituteFontName = "DroidArabicKufi"; // USE YOUR FONT NAME INSTEAD
        UITextView.appearance().substituteFontName = "DroidArabicKufi"; // USE YOUR FONT NAME INSTEAD
        UITextField.appearance().substituteFontName = "DroidArabicKufi";
        
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
