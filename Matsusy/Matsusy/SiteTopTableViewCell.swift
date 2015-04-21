//
//  SiteTopTableViewCell.swift
//  Matsusy
//
//  Created by 松下慶大 on 2015/04/21.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

class SiteTopTableViewCell: UITableViewCell {
    @IBOutlet weak var siteNameLabel: UILabel!
    @IBOutlet weak var siteTopImageView: UIImageView!
    @IBOutlet weak var imageMaskView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
    
        setSiteNmaeLabel()
        setTopImageView()
        
    }
    
    func setSiteNmaeLabel(){
        self.siteNameLabel.textAlignment = NSTextAlignment.Center
        self.siteNameLabel.textColor = UIColor.whiteColor()
        self.siteNameLabel.font = UIFont(name: "Helvetica-Light", size: 40)
    }
    
    func setTopImageView(){
        self.siteTopImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.siteTopImageView.layer.masksToBounds = true
    }

    func setImageMaskView(){
        self.alpha = 0.6
    }   
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
