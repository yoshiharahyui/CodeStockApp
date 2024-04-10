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
    private var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func postButton(_ sender: Any) {
        var memotext: String
        memotext = memoTextView.text ?? ""
        self.saveImage()
        self.saveData(with: memotext)
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
        setDoneButton()
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
    //memoTextとレコード時間を保存
    func saveData(with memotext: String) {
        let codestockData = CodeStockDataModel()
        try! realm.write {
            codestockData.memotext = memoTextView.text
            codestockData.recordDate = Date()
            realm.add(codestockData)
            print("😆\(codestockData)")
        }
    }
    
    
    func configure(memo: CodeStockDataModel) {
        codestockData.memotext = memoTextView.text
    }
    
    func setDoneButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y:0, width: 320, height: 40))
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        toolBar.items = [commitButton]
        memoTextView.inputAccessoryView = toolBar
    }
    
    @objc func tapDoneButton() {
        view.endEditing(true)
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

