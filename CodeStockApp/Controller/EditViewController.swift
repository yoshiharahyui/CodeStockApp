//
//  EditViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/05/28.
//

import Foundation
import UIKit
import RealmSwift

protocol UpdateDelegate {
    func updatePost(data: SpringCodeStockDataModel)
}

class EditViewController: UIViewController, UITextDragDelegate {
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func postButton(_ sender: Any) {
        self.updatespringData(data: SpringCodeStockDataModel())
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func addImageButtonAction(_ sender: Any) {
        let pickerView = UIImagePickerController()
        pickerView.sourceType = .photoLibrary
        pickerView.delegate = self
        self.present(pickerView, animated: true)
    }
    @IBOutlet weak var selectSeasonButton: UIButton!
    @IBOutlet weak var memoTextView: UITextView!
    
    var imageData: Data?
    var memotext: String = ""
    var recordDate: Date = Date()
    private let realm = try! Realm()
    private var springcodestockData = SpringCodeStockDataModel()
    private var summercodestockData = SummerCodeStockDataModel()
    private var fallcodestockData = FallCodeStockDataModel()
    private var wintercodestockData = WinterCodeStockDataModel()
    var updatedelegate: UpdateDelegate?
    
    
    //UIMenuの表示項目
    enum MenuType: String {
        case title = "Select Season"
        case spring = "SPRING"
        case summer = "SUMMER"
        case fall = "FALL"
        case winter = "WINTER"
    }
    
    //選択されたMenuType
    private var selectedMenuType = MenuType.title
    //選択されたUIMenuのitemを格納する変数
    private var uimenuitem: String?
    //取得したUIMenuの値を代入するために使う
    private let springAction = UIAction(title: "SPRING", image: nil, state: .on) { _ in}
    private let summerAction = UIAction(title: "SUMMER", image: nil, state: .on) { _ in}
    private let fallAction = UIAction(title: "FALL", image: nil, state: .on) { _ in}
    private let winterAction = UIAction(title: "WINTER", image: nil, state: .on) { _ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //memoTextView.placeHolder = "メモなどを入力してください。"
        memoTextView.backgroundColor = .gray
        displayData()
        setDoneButton()
        selectSeasonButton.layer.cornerRadius = 5
        configureMenuButton()
    }
    
    func configure(data: SpringCodeStockDataModel) {
        memotext = data.memotext
        imageData = data.imageData
        recordDate = data.recordDate
    }
    func summerconfigure(data: SummerCodeStockDataModel) {
        memotext = data.memotext
        imageData = data.imageData
        recordDate = data.recordDate
    }
    func fallconfigure(data: FallCodeStockDataModel) {
        memotext = data.memotext
        imageData = data.imageData
        recordDate = data.recordDate
    }
    func winterconfigure(data: WinterCodeStockDataModel) {
        memotext = data.memotext
        imageData = data.imageData
        recordDate = data.recordDate
    }
    
    
    private func displayData() {
        memoTextView.text = memotext
        imageView.image = UIImage(data: imageData!)
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
    
    //UIMenuの設定
    private func configureMenuButton() {
        var actions = [UIMenuElement]()
        
        //WINTER
        actions.append(UIAction(title: MenuType.winter.rawValue, image: nil, state: self.selectedMenuType == MenuType.winter ? .on : .off,
                                handler: { (_) in
            if self.winterAction.state == .on {
                self.uimenuitem = self.winterAction.title
            }
            self.selectedMenuType = .winter
            //UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
            self.configureMenuButton()
        }))
        //FALL
        actions.append(UIAction(title: MenuType.fall.rawValue, image: nil, state: self.selectedMenuType == MenuType.fall ? .on : .off,
                                handler: { (_) in
            if self.fallAction.state == .on {
                self.uimenuitem = self.fallAction.title
            }
            self.selectedMenuType = .fall
            //UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
            self.configureMenuButton()
        }))
        //SUMMER
        actions.append(UIAction(title: MenuType.summer.rawValue, image: nil, state: self.selectedMenuType == MenuType.summer ? .on : .off,
                                handler: { (_) in
            if self.summerAction.title == "SUMMER" {
                self.uimenuitem = self.summerAction.title
            }
            self.selectedMenuType = .summer
            //UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
            self.configureMenuButton()
        }))
        //SPRING
        actions.append(UIAction(title: MenuType.spring.rawValue, image: nil, state: self.selectedMenuType == MenuType.spring ? .on : .off,
                                handler: { (_) in
            if self.springAction.state == .on {
                self.uimenuitem = self.springAction.title
            }
            self.selectedMenuType = .spring
            //UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
            self.configureMenuButton()
        }))
        
        //UIButtonにUIMenuを設定
        selectSeasonButton.menu = UIMenu(title: "", options: .displayInline, children: actions)
        //これを書かないと表示できない場合があるので注意
        selectSeasonButton.showsMenuAsPrimaryAction = true
        //ボタンの表示を変更
        selectSeasonButton.setTitle(self.selectedMenuType.rawValue, for: .normal)
    }
    
    //データの更新
    func updatespringData(data: SpringCodeStockDataModel) {
        //更新したいデータを検索する
        //guard let targetupdateData = realm.objects(SpringCodeStockDataModel.self).filter("id == %@", data.id).first else { return }
        //UIImageViewを取得
        let setImage = imageView.image
        //pngDataに変換
        let pngimageData = setImage?.pngData()
        //print("\(String(describing: targetupdateData))")
        
        try! realm.write {
            data.imageData = pngimageData
            data.memotext = memoTextView.text
            data.recordDate = Date()
            updatedelegate?.updatePost(data: data)
        }
    }
}


//フォトライブラリから選んだ画像をimageViewに格納
extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        self.dismiss(animated: true)
    }
}
