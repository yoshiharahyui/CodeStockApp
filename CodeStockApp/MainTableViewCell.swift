//
//  MainTableViewCell.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/01.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var memolabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
   
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureMenuButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func configureMenuButton() {
        selectButton.showsMenuAsPrimaryAction = true
        let menuItems: [UIAction] = createMenuAction()
        let menu = UIMenu(title: "", children: menuItems)
        selectButton.menu = menu
//        let menuItems: [UIAction] = [UIAction(title: "Edit", handler: { _ in
//            // Editが選択された時の処理
//            print("Editが押された")
//        }),
//        UIAction(title: "Delete", handler: { _ in
//            // Deleteが選択された時の処理
//            print("Deleteが押された")
//        })
//        ]
//        let menu = UIMenu(title: "", children:menuItems)
//        selectButton.menu = menu
    }
    
    private func createMenuAction() -> [UIAction] {
        return [
            UIAction(title: "Edit", handler: { _ in
                self.showAlert(title: "Editだよ")
            }),
            UIAction(title: "Delete", handler: { _ in
                self.showAlert(title: "Are you sure you want to delete?")
            })
        ]
    }
    
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: {
                            //ボタンが押された時の処理
                            (action: UIAlertAction) -> Void in
                            print("OK")
                        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                            //ボタンが押された時の処理
                            (action: UIAlertAction) -> Void in
                            print("CANCEL")
                        })
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        //guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        windowScene?.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
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
