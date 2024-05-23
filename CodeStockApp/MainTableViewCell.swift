//
//  MainTableViewCell.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/01.
//

import UIKit

protocol CustomSpringCellDelegate {
    func customSpringCellDelegateDidTapButton(cell: UITableViewCell)
}
protocol CustomSummerCellDelegate {
    func cutomSummerCellDelegateDidTapButton(cell: UITableViewCell)
}
protocol CustomFallCellDelegate {
    func cutomFallCellDelegateDidTapButton(cell: UITableViewCell)
}
protocol CustomWinterCellDelegate {
    func cutomWinterCellDelegateDidTapButton(cell: UITableViewCell)
}

class MainTableViewCell: UITableViewCell {
    var springdelegate: CustomSpringCellDelegate?
    var summerdelegate: CustomSummerCellDelegate?
    var falldelegate: CustomFallCellDelegate?
    var winterdelegate: CustomWinterCellDelegate?
    
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var memolabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
   
    @IBAction func selectbutton(_ sender: Any) {
        springdelegate?.customSpringCellDelegateDidTapButton(cell: self)
        summerdelegate?.cutomSummerCellDelegateDidTapButton(cell: self)
        falldelegate?.cutomFallCellDelegateDidTapButton(cell: self)
        winterdelegate?.cutomWinterCellDelegateDidTapButton(cell: self)
    }
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    //UIImageViewのサイズ調整
    func resizedimage() {
        if let image = imageview?.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            //Update width constraint
            imageWidthConstraint.constant = imageWidth
            //Update width constraint
            imageHeightConstraint.constant = imageHeight
            //Update layout
            //view.layoutIfNeeded()
        }
    }
}
