//
//  EditSecondViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/06/09.
//

import Foundation
import UIKit
import RealmSwift

protocol SpringSecondUpdateDelegate {
    func springsecondupdatePost(secondupdateData: SpringCodeStockSecondDataModel)
}
protocol SummerSecondUpdateDelegate {
    func summersecondupdatePost(secondupdateData: SummerCodeStockSecondDataModel)
}
protocol FallSecondUpdateDelegate {
    func fallsecondupdatePost(secondupdateData: FallCodeStockSecondDataModel)
}
protocol WinterSecondUpdateDelegate {
    func wintersecondupdatePost(secondupdateData: WinterCodeStockSecondDataModel)
}
class EditSecondViewController: UIViewController, UITextDragDelegate {
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func postButton(_ sender: Any) {
        self.updatespringsecondData(data: springsecondupdateData)
        self.updatesummersecondData(data: summersecondupdateData)
        self.updatefallsecondData(data: fallsecondupdateData)
        self.updatewintersecondData(data: wintersecondupdateData)
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func addImageButtonAction(_ sender: Any) {
        let pickerView = UIImagePickerController()
        pickerView.sourceType = .photoLibrary
        pickerView.delegate = self
        self.present(pickerView, animated: true)
    }
    @IBOutlet weak var memoTextView: HintTextView!
    
    var imageData: Data?
    var memotext: String = ""
    var recordDate: Date = Date()
    private let realm = try! Realm()

    private var springcodestocksecondData = SpringCodeStockSecondDataModel()
    private var summercodestocksecondData = SummerCodeStockSecondDataModel()
    private var fallcodestocksecondData = FallCodeStockSecondDataModel()
    private var wintercodestocksecondData = WinterCodeStockSecondDataModel()

    var springsecondupdatedelegate: SpringSecondUpdateDelegate?
    var summersecondupdatedelegate: SummerSecondUpdateDelegate?
    var fallsecondupdatedelegate: FallSecondUpdateDelegate?
    var wintersecondupdatedelegate: WinterSecondUpdateDelegate?
    //編集対象のオブジェクトはクラス直下に保持しておく
    var springsecondupdateData = SpringCodeStockSecondDataModel()
    var summersecondupdateData = SummerCodeStockSecondDataModel()
    var fallsecondupdateData = FallCodeStockSecondDataModel()
    var wintersecondupdateData = WinterCodeStockSecondDataModel()

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
    
    func configure(data: SpringCodeStockSecondDataModel) {
        memotext = data.memotext
        imageData = data.imageData
        recordDate = data.recordDate
        //クラス直下のupdateDateに代入する
        springsecondupdateData = data
    }
    
    func summerconfigure(summerdata: SummerCodeStockSecondDataModel) {
        memotext = summerdata.memotext
        imageData = summerdata.imageData
        recordDate = summerdata.recordDate
        //クラス直下のupdateDateに代入する
        summersecondupdateData = summerdata
    }
    
    func fallconfigure(falldata: FallCodeStockSecondDataModel) {
        memotext = falldata.memotext
        imageData = falldata.imageData
        recordDate = falldata.recordDate
        //クラス直下のupdateDateに代入する
        fallsecondupdateData = falldata
    }
    
    func winterconfigure(winterdata: WinterCodeStockSecondDataModel) {
        memotext = winterdata.memotext
        imageData = winterdata.imageData
        recordDate = winterdata.recordDate
        //クラス直下のupdateDateに代入する
        wintersecondupdateData = winterdata
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
    func updatespringsecondData(data: SpringCodeStockSecondDataModel) {
        //更新したいデータを検索する
        guard let targetupdateData = realm.objects(SpringCodeStockSecondDataModel.self).filter("id == %@", data.id).first else { return }
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
            springsecondupdateData = targetupdateData
            springsecondupdatedelegate?.springsecondupdatePost(secondupdateData: targetupdateData)
        }
    }
    
    //Summerデータの更新
    func updatesummersecondData(data: SummerCodeStockSecondDataModel) {
        //更新したいデータを検索する
        guard let targetupdateData = realm.objects(SummerCodeStockSecondDataModel.self).filter("id == %@", data.id).first else { return }
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
            summersecondupdateData = targetupdateData
            summersecondupdatedelegate?.summersecondupdatePost(secondupdateData: targetupdateData)
        }
    }
    
    //Fallデータの更新
    func updatefallsecondData(data: FallCodeStockSecondDataModel) {
        //更新したいデータを検索する
        guard let targetupdateData = realm.objects(FallCodeStockSecondDataModel.self).filter("id == %@", data.id).first else { return }
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
            fallsecondupdateData = targetupdateData
            fallsecondupdatedelegate?.fallsecondupdatePost(secondupdateData: targetupdateData)
        }
    }
    
    //Winterデータの更新
    func updatewintersecondData(data: WinterCodeStockSecondDataModel) {
        //更新したいデータを検索する
        guard let targetupdateData = realm.objects(WinterCodeStockSecondDataModel.self).filter("id == %@", data.id).first else { return }
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
            wintersecondupdateData = targetupdateData
            wintersecondupdatedelegate?.wintersecondupdatePost(secondupdateData: targetupdateData)
        }
    }
}

//フォトライブラリから選んだ画像をimageViewに格納
extension EditSecondViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            //取得した画像をresizeImage関数を使用し圧縮
            let compressedImage = image.resizeImage(withPercentage: 0.3)!
            imageView.image = compressedImage
            self.dismiss(animated: true)
        }
    }
}
