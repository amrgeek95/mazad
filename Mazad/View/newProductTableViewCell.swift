////
//  newProductTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 4/26/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import ImagePicker
import Lightbox
import DropDown
class newProductTableViewCell: UITableViewCell , ImagePickerDelegate ,UITextViewDelegate{

    var parent : addProductViewController!
    var dropDown = DropDown()
     var dropDown2 = DropDown()
    var dropDown3 = DropDown()
    var category_id = ""
    var city_id = ""
    var sub_id = ""
    var child_id = ""
    var imageArray = [String]()
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var bodyText: UITextView!
    
    @IBOutlet weak var cityBtn: UIButton!
    
    @IBOutlet weak var imageLabel: UILabel!
    
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var childrenBtn: UIButton!
    
    @IBOutlet weak var childrenTop: NSLayoutConstraint!
    @IBOutlet weak var subBtn: UIButton!
    @IBOutlet weak var imageBtn: UIButton!
    @IBAction func categoryAction(_ sender: Any) {
    }
    @IBAction func checkAction(_ sender: Any) {
        
    }
    
    @IBAction func subAction(_ sender: Any) {
        dropDown2.show()
    }
    @IBAction func cityAction(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func childrenAction(_ sender: Any) {
        dropDown3.show()
    }
    
    @IBAction func imageAction(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 6
        self.parent.present(imagePickerController, animated: true, completion: nil)
    }
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        // let images = imageAssets
        MBProgressHUD.showAdded(to: self.parent.view, animated: true)
        var upload_url = base_url + "upload_image"
        // images is he return from the delegate
        print(images)
        var imageParamName = "parameters"
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            for image in images {
                let imageData =  UIImageJPEGRepresentation(image, 0)!
                multipartFormData.append(imageData, withName: "\(imageParamName)[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            /*
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            */
        }, to: upload_url,
           
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("success")
                    print(response)
                     if let results = response.result.value as? [String:AnyObject]{
                        if let result_image = results["images"] as? [String] {
                            self.imageArray = result_image
                        MBProgressHUD.hide(for: self.parent.view, animated: true)
                        }else{
                            print("why")
                             MBProgressHUD.hide(for: self.parent.view, animated: true)
                            Mazad.toastView(messsage: "حدث خطأ اعد المحاولة", view: self.parent.view)
                        }
                    }
                   
                }
            case .failure(let error):
                print(error)
                MBProgressHUD.hide(for: self.parent.view, animated: true)
                Mazad.toastView(messsage: "حدث خطأ اعد المحاولة", view: self.parent.view)
            }
            
        })
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        
    }
    @IBAction func submitAction(_ sender: Any) {
        var parameters = [String:AnyObject]()
       
        guard inputValidation(text: self.titleText.text!, message: "يجب كتابة عنوان للأعلان", view: self.parent.view) else{
            
            return
        }
        let title = self.titleText.text!
        print("titlLEngth\(title.length)")
        if title.length > 30 {
            Mazad.toastView(messsage: "يجب ان يقل العنوان عن ٣٠ حرف", view: self.parent.view)
       return
        }
        guard inputValidation(text: bodyText.text!, message: "يجب كتابة محتوي الاعلان", view: self.parent.view) else{
            return
        }
        guard inputValidation(text: phoneText.text!, message: "يجب كتابة رقم جوال او بريد الاكتروني للتواصل", view: self.parent.view) else{
            return
        }
        guard !imageArray.isEmpty else {
            Mazad.toastView(messsage: "يجب رفع صورة واحدة علي الاقل", view: self.parent.view)
            return
        }
        parameters["name"] = titleText.text as AnyObject
        parameters["user_id"] = userData["id"] as AnyObject
        parameters["category_id"] = category_id as AnyObject
        if city_id == "" {
            city_id = dropDown.selectedItem as? String ?? ""
        }
        if sub_id == "" {
            sub_id  = dropDown2.selectedItem as? String ?? ""
        }
        if child_id == "" {
            child_id  = dropDown3.selectedItem as? String ?? ""
        }
        print(sub_id)
        print(city_id)
        
    parameters["city_id"] = city_id as AnyObject
        parameters["subcategory_id"] = sub_id as AnyObject
          parameters["secondary_id"] = child_id as AnyObject
        parameters["body"] = bodyText.text as AnyObject
        parameters["mobile"] = phoneText.text as AnyObject
        parameters["images"] = imageArray as AnyObject
        var url = base_url + "add_product"
        print(parameters)
        self.submitBtn.isEnabled = false
        MBProgressHUD.showAdded(to: self.parent.view, animated: true)
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            (response) in
            print(response)
              MBProgressHUD.hide(for: self.parent.view,animated:true)
            if let results = response.result.value as? [String:AnyObject]{
                print(results)
              
                if results["status"] as? Bool == true {
                    self.parent.view.makeToast("تم اضافة الاعلان")
                   // self.parent.dismiss(animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
       self.bodyText.text = "اكتب محتوي الاعلان"
        self.bodyText.textColor = UIColor.lightGray
       self.bodyText.delegate = self
        self.bodyText.textAlignment = .right
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        bodyText.layer.borderColor = color
        bodyText.layer.borderWidth = 0.5
        bodyText.layer.cornerRadius = 5
        bodyText.isSelectable = true
        bodyText.isEditable = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       
        
        if textView.text.isEmpty {
            textView.text = "اكتب محتوي الاعلان"
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
       
    }
    /*
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        if textView.text.isEmpty {
            textView.text = "اكتب محتوي الاعلان"
            textView.textColor = UIColor.lightGray
        }
    }
    */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
