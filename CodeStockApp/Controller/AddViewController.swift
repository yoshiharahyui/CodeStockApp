//
//  AddViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/05.
//

import Foundation
import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func postButton(_ sender: Any) {
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
