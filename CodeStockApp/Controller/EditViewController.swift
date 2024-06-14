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
    func updatePost(updateData: SpringCodeStockDataModel)
}
protocol SummerUpdateDelegate {
    func summerupdatePost(summerupdateData: SummerCodeStockDataModel)
}
protocol FallUpdateDelegate {
    func fallupdatePost(fallupdateData: FallCodeStockDataModel)
}
protocol WinterUpdateDelegate {
    func winterupdatePost(winterupdateData: WinterCodeStockDataModel)
}
class EditViewController: UIViewController, UITextDragDelegate {
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func postButton(_ sender: Any) {
        self.updatespringData(data: updateData)
        self.updatesummerData(data: summerupdateData)
        self.updatefallData(data: fallupdateData)
        self.updatewinterData(data: winterupdateData)
        self.dismiss(animated: true, completion: nil)
        //選択されたUIMenuごとに保存先を分ける
        if uimenuitem == "SPRING" {
            print("春")
        } else if uimenuitem == "SUMMER" {
            print("夏")
        } else if uimenuitem == "Fall" {
            print("秋")
        } else if uimenuitem == "WINTER" {
            print("冬")
        } else if uimenuitem == nil {
            return
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func addImageButtonAction(_ sender: Any) {
        let pickerView = UIImagePickerController()
        pickerView.sourceType = .photoLibrary
        pickerView.delegate = self
        self.present(pickerView, animated: true)
    }
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
    var summerupdatedelegate: SummerUpdateDelegate?
    var fallupdatedelegate: FallUpdateDelegate?
    var winterupdatedelegate: WinterUpdateDelegate?
    //編集対象のオブジェクトはクラス直下に保持しておく
    var updateData = SpringCodeStockDataModel()
    var summerupdateData = SummerCodeStockDataModel()
    var fallupdateData = FallCodeStockDataModel()
    var winterupdateData = WinterCodeStockDataModel()
    
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
        displayData()
        setDoneButton()
    }
    
    func configure(data: SpringCodeStockDataModel) {
        memotext = data.memotext
        imageData = data.imageData
        recordDate = data.recordDate
        //クラス直下のupdateDataに代入する
        updateData = data
    }
    func summerconfigure(summerdata: SummerCodeStockDataModel) {
        memotext = summerdata.memotext
        imageData = summerdata.imageData
        recordDate = summerdata.recordDate
        //クラス直下のupdateDataに代入する
        summerupdateData = summerdata
    }
    func fallconfigure(falldata: FallCodeStockDataModel) {
        memotext = falldata.memotext
        imageData = falldata.imageData
        recordDate = falldata.recordDate
        //クラス直下のupdateDataに代入する
        fallupdateData = falldata
    }
    func winterconfigure(data: WinterCodeStockDataModel) {
        memotext = data.memotext
        imageData = data.imageData
        recordDate = data.recordDate
        //クラス直下のupdateDataに代入する
        winterupdateData = data
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
        
    }
    
    //Springデータの更新
    func updatespringData(data: SpringCodeStockDataModel) {
        //更新したいデータを検索する
        guard let targetupdateData = realm.objects(SpringCodeStockDataModel.self).filter("id == %@", data.id).first else { return }
        //UIImageViewを取得
        let setImage = imageView.image
        //pngDataに変換
        let pngimageData = setImage?.pngData()
        //print("\(String(describing: targetupdateData))")
        try! realm.write {
            targetupdateData.imageData = pngimageData
            targetupdateData.memotext = memoTextView.text
            targetupdateData.recordDate = Date()
            //クラス直下変数に代入して同じインスタンスにする
            updateData = targetupdateData
            updatedelegate?.updatePost(updateData: targetupdateData)
        }
    }
    //Summerデータの更新
    private func updatesummerData(data: SummerCodeStockDataModel) {
        //更新したいデータを検索する
        guard let targetupdateData = realm.objects(SummerCodeStockDataModel.self).filter("id == %@", data.id).first else { return }
        //UIImageViewを取得
        let setImage = imageView.image
        //pngDataに変換
        let pngimageData = setImage?.pngData()
        try! realm.write {
            targetupdateData.imageData = pngimageData
            targetupdateData.memotext = memoTextView.text
            targetupdateData.recordDate = Date()
            //クラス直下変数に代入して同じインスタンスにする
            summerupdateData = targetupdateData
            summerupdatedelegate?.summerupdatePost(summerupdateData: targetupdateData)
        }
        
    }
    //Fallデータの更新
    private func updatefallData(data: FallCodeStockDataModel) {
        //更新したいデータを検索する
        guard let targetupdateData = realm.objects(FallCodeStockDataModel.self).filter("id == %@", data.id).first else { return }
        //UIImageViewを取得
        let setImage = imageView.image
        //pngDataに変換
        let pngimageData = setImage?.pngData()
        try! realm.write {
            targetupdateData.imageData = pngimageData
            targetupdateData.memotext = memoTextView.text
            targetupdateData.recordDate = Date()
            //クラス直下変数に代入して同じインスタンスにする
            fallupdateData = targetupdateData
            fallupdatedelegate?.fallupdatePost(fallupdateData: targetupdateData)
        }
    }
    //Winterデータの更新
    private func updatewinterData(data: WinterCodeStockDataModel) {
        //更新したいデータを検索する
        guard let targetupdateData = realm.objects(WinterCodeStockDataModel.self).filter("id == %@", data.id).first else { return }
        //UIImageViewを取得
        let setImage = imageView.image
        //pngDataに変換
        let pngimageData = setImage?.pngData()
        try! realm.write {
            targetupdateData.imageData = pngimageData
            targetupdateData.memotext = memoTextView.text
            targetupdateData.recordDate = Date()
            //クラス直下変数に代入して同じインスタンスにする
            winterupdateData = targetupdateData
            winterupdatedelegate?.winterupdatePost(winterupdateData: targetupdateData)
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
