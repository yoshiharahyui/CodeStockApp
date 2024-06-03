//
//  SpringViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/03/30.
//

import Foundation
import UIKit
import RealmSwift

class SpringViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var springcodestockList: [SpringCodeStockDataModel] = []
    let realm = try! Realm()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //セルの登録
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.delegate = self
        setcodestockData()
        self.tableView.reloadData()
        //セルの可変
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    enum SelectMenu: String {
        case edit = "EDIT"
        case delete = "DELETE"
    }
    // 選択されたMenuType
        var selectedMenuType = SelectMenu.edit
    
    func configureSelectMenu() {
        var actions = [UIMenuElement]()
            // HIGH
            actions.append(UIAction(title: SelectMenu.edit.rawValue, image: nil, state: self.selectedMenuType == SelectMenu.edit ? .on : .off,
                                    handler: { (_) in
                                        self.selectedMenuType = .edit
                                        // UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
                                        self.configureSelectMenu()
                                    }))
            // MID
            actions.append(UIAction(title: SelectMenu.delete.rawValue, image: nil, state: self.selectedMenuType == SelectMenu.delete ? .on : .off,
                                    handler: { (_) in
                                        self.selectedMenuType = .delete
                                        // UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
                                        self.configureSelectMenu()
                                    }))
    }
    
    func setcodestockData() {
        let result = realm.objects(SpringCodeStockDataModel.self).sorted(byKeyPath: "recordDate", ascending: false)
        springcodestockList = Array(result)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return springcodestockList.count
    }
    private let formatter = DateFormatter()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let springcell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let springcodestockDataModel: SpringCodeStockDataModel = springcodestockList[indexPath.row]
        let defaultImage = UIImage(named: "defaultImage")

        //dateFormatterの設定
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = formatter.string(from: springcodestockDataModel.recordDate)
        springcell.datelabel.text = "\(date)"

        springcell.datelabel.textColor = .black
        springcell.memolabel.text = springcodestockDataModel.memotext
        springcell.memolabel.textColor = .black
        springcell.delegate = self

        //セル生成時にindexPathを渡しておく
        springcell.indexPath = indexPath
        
        //if letを使いData?をアンラップし、dataがある時とnilの時で分けた
        if springcodestockDataModel.imageData != nil {
            springcell.imageview.image = UIImage(data: springcodestockDataModel.imageData!)
        } else {
            springcell.imageView?.image = defaultImage
        }
        //MaintableViewCellのresizedimage()を実行する
        springcell.resizedimage()
        view.layoutIfNeeded()
        //セルの背景色変更
        springcell.backgroundColor = UIColor(red: 255/255, green: 227/255, blue: 254/255, alpha: 1.0)
        return springcell
    }
}

//新しく投稿する際のdelegate
extension SpringViewController: PostDelegate {
    func newPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
}
//編集のためのdelegate
extension SpringViewController: UpdateDelegate {
    func updatePost(updateData: SpringCodeStockDataModel) {
        setcodestockData()
        tableView.reloadData()
    }
}

extension SpringViewController: MainTableViewCellDelegate {
    func giveEditAction(at indexPath: IndexPath) {
        let targetData = springcodestockList[indexPath.row]
        //Editボタン押した時の処理
        let editstoryboard = UIStoryboard(name: "EditView", bundle: nil)
        let EditVC = editstoryboard.instantiateViewController(withIdentifier: "editview") as! EditViewController
        EditVC.updatedelegate = self
        //表示しているインスタンス
        var editvc = EditViewController()
        EditVC.configure(data: targetData)
        //EditVC.updatespringData(data: targetData)
        editvc = EditVC
        editvc.modalPresentationStyle = .formSheet
        present(editvc, animated: true, completion: nil)
    }
    
    //アラートを押してカスタムセルを削除するメソッド
    func giveAction(at indexPath: IndexPath) {
        //IndexPathをもとに削除するオブジェクトを特定
        let target = springcodestockList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(target)
        }
        //配列からそのオブジェクトを削除
        springcodestockList.remove(at: indexPath.row)
        //セルを削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}
