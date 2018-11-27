//
//  EditPersonCell.swift
//  LuckyX
//
//  Created by XuWeinan on 2018/11/27.
//  Copyright © 2018 徐炜楠. All rights reserved.
//

import UIKit

class EditPersonCell: UITableViewCell {

    @IBOutlet weak var color: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var wish: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
