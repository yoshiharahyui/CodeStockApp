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
        self.saveImage()
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    //フォトライブラリにアクセス用
    @IBAction func addImageButtonAction(_ sender: Any) {
        let pickerView = UIImagePickerController()
        pickerView.sourceType = .photoLibrary
        pickerView.delegate = self
        self.present(pickerView, animated: true)
        
    }
    @IBAction func selectSeasonButton(_ sender: Any) {
        print("季節選択ボタンが選ばれました")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //画像保存
    func saveImage() {
        
        let codestockData = CodeStockDataModel()
        //codestockData.imageData = imageData
        //UIImageViewを取得
        let setImage = imageView.image
        //pngDataに変換
        let setimageData = setImage?.pngData()
        //データモデルのプロパティに代入
        codestockData.imageData = setimageData
        try! realm.write {
        realm.add(codestockData)
            print("😄\(codestockData)")
        }
    }
}
//フォトライブラリから選んだ画像をimageViewに格納
extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        self.dismiss(animated: true)
        let imageData = image.pngData()
    }
}

