//
//  AddSecondViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/11.
//

import Foundation
import UIKit
import RealmSwift

class AddSecondViewController: UIViewController {
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBAction func addImageButtonAction(_ sender: Any) {
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postAction(_ sender: Any) {
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selectSeasonButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
