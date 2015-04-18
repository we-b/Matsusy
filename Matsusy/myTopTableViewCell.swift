//
//  myTopTableViewCell.swift
//  Matsusy
//
//  Created by 松下慶大 on 2015/04/17.
//  Copyright (c) 2015年 matsushita keita. All rights reserved.
//

import UIKit

//初めのセル(ユーザのアイコン、ヘッダー用)
class myTopTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        var myphoto = self.viewWithTag(2) as UIImageView
        myphoto.layer.cornerRadius = 3
        myphoto.layer.borderWidth = 2
        myphoto.layer.borderColor = UIColor.whiteColor().CGColor
        myphoto.layer.masksToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
