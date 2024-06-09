//
//  EditSecondViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/06/09.
//

import Foundation
import UIKit
import RealmSwift

class EditSecondViewController: UIViewController, UITextDragDelegate {
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
}
