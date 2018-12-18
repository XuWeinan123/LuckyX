//
//  RightPersonCell.swift
//  LuckyX
//
//  Created by XuWeinan on 2018/11/16.
//  Copyright © 2018 XuWeinan. All rights reserved.
//

import UIKit

class RightPersonCell: UITableViewCell {

    @IBOutlet weak var color: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var prize: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
