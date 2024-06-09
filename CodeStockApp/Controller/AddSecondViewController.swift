//
//  AddSecondViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/11.
//

import Foundation
import UIKit
import RealmSwift
import Parchment

protocol PostSpringSecondDelegate {
    func newSecondPost(memotext: String)
}
protocol PostSummerSecondDelegate {
    func newsummerSecondPost(memotext: String)
}
protocol PostFallSecondDelegate {
    func newfallSecondPost(memotext: String)
}
protocol PostWinterSecondDelegate {
    func newwinterSecondPost(memotext: String)
}

class AddSecondViewController: UIViewController {
    
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
    
    private var springcodestocksecondData = SpringCodeStockSecondDataModel()
    private var summercodestocksecondData = SummerCodeStockSecondDataModel()
    private var fallcodestocksecondData = FallCodeStockSecondDataModel()
    private var wintercodestocksecondData = WinterCodeStockSecondDataModel()
    
    private let realm = try! Realm()
    
    var springseconddelegate: PostSpringSecondDelegate?
    var summerseconddelegate: PostSummerSecondDelegate?
    var fallseconddelegate: PostFallSecondDelegate?
    var winterseconddelegate: PostWinterSecondDelegate?
    var getsecondindex: PagingIndexItem!

    
    @IBOutlet weak var memoTextView: HintTextView!
    
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
        let alert: UIAlertController = UIAlertController(title: "Alert!", message: "Please choose Season", preferredStyle: .alert)
        var memotext: String
        memotext = memoTextView.text ?? ""
        
        //uimenuitemが選択されてない時用のアラート
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: {
                    //ボタンが押された時の処理
                    (action: UIAlertAction) -> Void in
                })
                //キャンセルボタン
                let cancelAction: UIAlertAction = UIAlertAction(title: "CANCEL", style: .default, handler: {
                    //ボタンが押された時の処理
                    (action: UIAlertAction) -> Void in
                })

                //UIAlertControllerにActionを追加
                alert.addAction(defaultAction)
                alert.addAction(cancelAction)
        
        //選択されたUIMenuごとに保存先を分ける
        if uimenuitem == "SPRING" {
            self.savespringData(with: memotext)
            springseconddelegate?.newSecondPost(memotext: memotext)
            self.dismiss(animated: true, completion: nil)
        } else if uimenuitem == "SUMMER" {
            self.savesummerData(with: memotext)
            summerseconddelegate?.newsummerSecondPost(memotext: memotext)
            self.dismiss(animated: true, completion: nil)
        } else if uimenuitem == "FALL" {
            self.savefallData(with: memotext)
            fallseconddelegate?.newfallSecondPost(memotext: memotext)
            self.dismiss(animated: true, completion: nil)
        } else if uimenuitem == "WINTER" {
            self.savewinterData(with: memotext)
            winterseconddelegate?.newwinterSecondPost(memotext: memotext)
            self.dismiss(animated: true, completion: nil)
        } else if uimenuitem == nil {
            //Alertを表示
            present(alert, animated: true, completion: nil)
            return
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selectSeasonButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDoneButton()
        self.configureMenuButton()
        selectSeasonButton.layer.cornerRadius = 5
        memoTextView.placeHolder = "メモなどを入力してください。"
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
    
    //データ保存
    private func savespringData(with memotext: String) {
        try! realm.write {
            //UIImageViewを取得
            let setImage = imageView.image
            //pngDataに変換
            let pngimageData = setImage?.pngData()
            //データモデルのプロパティに代入
            springcodestocksecondData.imageData = pngimageData
            springcodestocksecondData.memotext = memoTextView.text
            springcodestocksecondData.recordDate = Date()
        realm.add(springcodestocksecondData)
        }
    }
    private func savesummerData(with memotext: String) {
        try! realm.write {
            //UIImageViewを取得
            let setImage = imageView.image
            //pngDataに変換
            let pngimageData = setImage?.pngData()
            //データモデルのプロパティに代入
            summercodestocksecondData.imageData = pngimageData
            summercodestocksecondData.memotext = memoTextView.text
            summercodestocksecondData.recordDate = Date()
        realm.add(summercodestocksecondData)
        }
    }
    private func savefallData(with memotext: String) {
        try! realm.write {
            //UIImageViewを取得
            let setImage = imageView.image
            //pngDataに変換
            let pngimageData = setImage?.pngData()
            //データモデルのプロパティに代入
            fallcodestocksecondData.imageData = pngimageData
            fallcodestocksecondData.memotext = memoTextView.text
            fallcodestocksecondData.recordDate = Date()
        realm.add(fallcodestocksecondData)
        }
    }
    private func savewinterData(with memotext: String) {
        try! realm.write {
            //UIImageViewを取得
            let setImage = imageView.image
            //pngDataに変換
            let pngimageData = setImage?.pngData()
            //データモデルのプロパティに代入
            wintercodestocksecondData.imageData = pngimageData
            wintercodestocksecondData.memotext = memoTextView.text
            wintercodestocksecondData.recordDate = Date()
        realm.add(wintercodestocksecondData)
        }
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
