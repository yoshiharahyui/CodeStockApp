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
    
    private var codestocksecondData = CodeStockSecondDataModel()
    private let realm = try! Realm()
    private var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBAction func addImageButtonAction(_ sender: Any) {
        let pickerView = UIImagePickerController()
        pickerView.sourceType = .photoLibrary
        pickerView.delegate = self
        self.present(pickerView, animated: true)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postAction(_ sender: Any) {
        var memotext: String
        memotext = memoTextView.text ?? ""
        self.saveData(with: memotext)
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selectSeasonButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDoneButton()
        //SelectSeasonButtonにアイテム追加、動くようにするためのコード
        selectSeasonButton.menu = addMenuItems()
        selectSeasonButton.showsMenuAsPrimaryAction = true
    }
    
    //投稿画面のSelectSeasonButtonのアイテム
    private func addMenuItems() -> UIMenu{
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Winter", image: UIImage(systemName: "play"), handler: { (_) in print("aaa")
            }),
            UIAction(title: "Fall", image: UIImage(systemName: "play"), handler: { (_) in print("iii")
            }),
            UIAction(title: "Summer", image: UIImage(systemName: "play"), handler: { (_) in print ("eee")
            }),
            UIAction(title: "Spring", image: UIImage(systemName: "play"), handler: { (_) in print("gvvv")
            }),
        ])
        return menuItems
    }
    
    //画像保存
    private func saveData(with memotext: String) {
        let codestocksecondData = CodeStockSecondDataModel()
        
        try! realm.write {
            //UIImageViewを取得
            let setImage = imageView.image
            //pngDataに変換
            let pngimageData = setImage?.pngData()
            //データモデルのプロパティに代入
            codestocksecondData.imageData = pngimageData
            codestocksecondData.memotext = memoTextView.text
            codestocksecondData.recordDate = Date()
        realm.add(codestocksecondData)
        }
    }
    
    private func configure(memo: CodeStockSecondDataModel) {
        codestocksecondData.memotext = memoTextView.text
        codestocksecondData.recordDate = memo.recordDate
    }
    
    private func setDoneButton() {
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
extension AddSecondViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        self.dismiss(animated: true)
        //let imageData = image.pngData()
    }
}
