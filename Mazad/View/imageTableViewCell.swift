//
//  imageTableViewCell.swift
//  Mazad
//
//  Created by amr sobhy on 4/29/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit

import NYTPhotoViewer
class imageTableViewCell: UITableViewCell , NYTPhotosViewControllerDelegate{
    var img_url: UIImage?
    var parent: ProductViewController?
    var imgData : Data?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // containerView.borderRound(border: 0.2, corner: 10)
    }
    func imageBtn(_ sender: Any) {
        let photo = ExamplePhoto(image: img_url, imageData: imgData, attributedCaptionTitle: NSAttributedString(string: ""))
        
        photo.attributedCaptionSummary = NSAttributedString(string:
            "image1", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        photo.attributedCaptionCredit = NSAttributedString(string:  "image2", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        let photosViewController = NYTPhotosViewController()
        parent?.present(photosViewController, animated: true, completion: nil)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
