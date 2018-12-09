//
//  PrizeSettingCell.swift
//  LuckyX
//
//  Created by 徐炜楠 on 2018/12/9.
//  Copyright © 2018 徐炜楠. All rights reserved.
//

import UIKit

class PrizeSettingCell: UICollectionViewCell {
    @IBOutlet var prizeImageView: UIImageView!
    @IBOutlet var nameAndNumber: UILabel!
    override func awakeFromNib() {
        prizeImageView.layer.cornerRadius = 8.0
    }
}
