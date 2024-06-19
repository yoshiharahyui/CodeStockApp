//
//  AddViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/05.
//

import Foundation
import UIKit
import RealmSwift
import Parchment

protocol PostDelegate {
    func newPost(memotext: String)
}
protocol PostSummerDelegate {
    func newsummerPost(memotext: String)
}
protocol PostFallDelegate {
    func newfallPost(memotext: String)
}
protocol PostWinterDelegate {
    func newwinterPost(memotext: String)
}

class AddViewController: UIViewController, UITextViewDelegate {
    
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
    
    private var springcodestockData = SpringCodeStockDataModel()
    private var summercodestockData = SummerCodeStockDataModel()
    private var fallcodestockData = FallCodeStockDataModel()
    private var wintercodestockData = WinterCodeStockDataModel()
    private let realm = try! Realm()
    
    var delegate: PostDelegate?
    var summerdelegate: PostSummerDelegate?
    var falldelegate: PostFallDelegate?
    var winterdelegate: PostWinterDelegate?
    var getindex: PagingIndexItem!
    
    
    @IBOutlet weak var memoTextView: HintTextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func postButton(_ sender: Any) {
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
            delegate?.newPost(memotext: memotext)
            self.dismiss(animated: true, completion: nil)
        } else if uimenuitem == "SUMMER" {
            self.savesummerData(with: memotext)
            summerdelegate?.newsummerPost(memotext: memotext)
            self.dismiss(animated: true, completion: nil)
        } else if uimenuitem == "FALL" {
            self.savefallData(with: memotext)
            falldelegate?.newfallPost(memotext: memotext)
            self.dismiss(animated: true, completion: nil)
        } else if uimenuitem == "WINTER" {
            self.savewinterData(with: memotext)
            winterdelegate?.newwinterPost(memotext: memotext)
            self.dismiss(animated: true, completion: nil)
        } else if uimenuitem == nil {
            //Alertを表示
            present(alert, animated: true, completion: nil)
            return
        }
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
    @IBOutlet weak var selectSeasonButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDoneButton()
        self.configureMenuButton()
        selectSeasonButton.layer.cornerRadius = 5
        memoTextView.placeHolder = "Please enter a note."
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
            springcodestockData.imageData = pngimageData
            springcodestockData.memotext = memoTextView.text
            springcodestockData.recordDate = Date()
        realm.add(springcodestockData)
        }
    }
    private func savesummerData(with memotext: String) {
        try! realm.write {
            //UIImageViewを取得
            let setImage = imageView.image
            //pngDataに変換
            let pngimageData = setImage?.pngData()
            //データモデルのプロパティに代入
            summercodestockData.imageData = pngimageData
            summercodestockData.memotext = memoTextView.text
            summercodestockData.recordDate = Date()
        realm.add(summercodestockData)
        }
    }
    private func savefallData(with memotext: String) {
        try! realm.write {
            //UIImageViewを取得
            let setImage = imageView.image
            //pngDataに変換
            let pngimageData = setImage?.pngData()
            //データモデルのプロパティに代入
            fallcodestockData.imageData = pngimageData
            fallcodestockData.memotext = memoTextView.text
            fallcodestockData.recordDate = Date()
        realm.add(fallcodestockData)
        }
    }
    private func savewinterData(with memotext: String) {
        try! realm.write {
            //UIImageViewを取得
            let setImage = imageView.image
            //pngDataに変換
            let pngimageData = setImage?.pngData()
            //データモデルのプロパティに代入
            wintercodestockData.imageData = pngimageData
            wintercodestockData.memotext = memoTextView.text
            wintercodestockData.recordDate = Date()
        realm.add(wintercodestockData)
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
extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            //取得した画像をresizeImage関数を使用し圧縮
            let compressedImage = image.resizeImage(withPercentage: 0.6)!
            imageView.image = compressedImage
            self.dismiss(animated: true)
        }
    }
}
//UIImageを圧縮するための関数
extension UIImage {
    // percentage:圧縮率
    func resizeImage(withPercentage percentage: CGFloat) -> UIImage? {
        // 圧縮後のサイズ情報
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        // 圧縮画像を返す
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
