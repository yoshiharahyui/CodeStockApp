//
//  EditViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/05/28.
//

import Foundation
import UIKit
import RealmSwift

class EditViewController: UIViewController, UITextDragDelegate {
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func postButton(_ sender: Any) {
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func addImageButtonAction(_ sender: Any) {
    }
    @IBOutlet weak var selectSeasonButton: UIButton!
    @IBOutlet weak var memoTextView: HintTextView!
}
