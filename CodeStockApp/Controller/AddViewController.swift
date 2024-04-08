//
//  AddViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/05.
//

import Foundation
import UIKit
import RealmSwift

class AddViewController: UIViewController {
    
    private var codestockData = CodeStockDataModel()
    private let realm = try! Realm()
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func postButton(_ sender: Any) {
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func selectSeasonButton(_ sender: Any) {
        print("季節選択ボタンが選ばれました")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func saveImage(_ imageData: Data) {
        
        let codestockData = CodeStockDataModel()
        codestockData.imageData = imageData
        
        //pngで保存する場合
        //let pngImageData = imageView.image?.pngData()
        try! realm.write {
        realm.add(codestockData)
            print("😄\(codestockData)")
        }
    }
}


