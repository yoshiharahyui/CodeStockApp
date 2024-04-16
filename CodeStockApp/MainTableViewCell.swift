//
//  MainTableViewCell.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/01.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var selectbutton: UIButton!
    @IBOutlet weak var memolabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
