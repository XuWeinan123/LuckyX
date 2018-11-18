//
//  PersonCell.swift
//  LuckyX
//
//  Created by 徐炜楠 on 2018/11/18.
//  Copyright © 2018 徐炜楠. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    @IBOutlet var goldEggImage: UIImageView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var label: UILabel!
    override func awakeFromNib() {
        bgView.layer.cornerRadius = bgView.frame.height/2
    }
    func unsmash(){
        bgView.isHidden = true
        label.isHidden = true
        goldEggImage.isHidden = false
    }
    func smash(){
        bgView.isHidden = false
        label.isHidden = false
        goldEggImage.isHidden = true
    }
    
}
