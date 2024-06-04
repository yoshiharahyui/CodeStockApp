//
//  WinterViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/03/30.
//

import Foundation
import UIKit
import RealmSwift

class WinterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var wintercodestockList: [WinterCodeStockDataModel] = []
    let addVC = AddViewController()
    
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
    
    func setcodestockData() {
        let realm = try! Realm()
        let result = realm.objects(WinterCodeStockDataModel.self).sorted(byKeyPath: "recordDate", ascending: false)
        wintercodestockList = Array(result)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wintercodestockList.count
    }
    private let formatter = DateFormatter()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wintercell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let wintercodestockDataModel: WinterCodeStockDataModel = wintercodestockList[indexPath.row]
        let defaultImage = UIImage(named: "defaultImage")
        //dateFormatterの設定
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = formatter.string(from: wintercodestockDataModel.recordDate)
        wintercell.datelabel.text = "\(date)"
        wintercell.datelabel.textColor = .black
        wintercell.memolabel.text = wintercodestockDataModel.memotext
        wintercell.memolabel.textColor = .black
        wintercell.delegate = self
        wintercell.indexPath = indexPath
        
        //if letを使いData?をアンラップし、dataがある時とnilの時で分けた
        if wintercodestockDataModel.imageData != nil {
            wintercell.imageview.image = UIImage(data: wintercodestockDataModel.imageData!)
        } else {
            wintercell.imageview?.image = defaultImage
        }
        //MaintableViewCellのresizedimage()を実行する
        wintercell.resizedimage()
        view.layoutIfNeeded()
        //セルの背景色変更
        wintercell.backgroundColor = UIColor(red: 202/255, green: 237/255, blue: 250/255, alpha: 1.0)
        return wintercell
    }
}
//新しく投稿する際のdelegate
extension WinterViewController: PostWinterDelegate {
    func newwinterPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
}
//編集のためのdelegate
extension WinterViewController: WinterUpdateDelegate {
    func winterupdatePost(winterupdateData: WinterCodeStockDataModel) {
        setcodestockData()
        tableView.reloadData()
    }
}

//アラートを押してカスタムセルを削除するメソッド
extension WinterViewController: MainTableViewCellDelegate {
    func giveEditAction(at indexPath: IndexPath) {
        let targetData = wintercodestockList[indexPath.row]
        //Editボタン押した時の処理
        let editstoryboard = UIStoryboard(name: "EditView", bundle: nil)
        let EditVC = editstoryboard.instantiateViewController(withIdentifier: "editview") as! EditViewController
        var editvc = EditViewController()
        EditVC.winterupdatedelegate = self
        EditVC.winterconfigure(data: targetData)
        editvc = EditVC
        editvc.modalPresentationStyle = .formSheet
        present(editvc, animated: true, completion: nil)
    }
    
    func giveAction(at indexPath: IndexPath) {
        //IndexPathをもとに削除するオブジェクトを特定
        let target = wintercodestockList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(target)
        }
        //配列からそのオブジェクトを削除
        wintercodestockList.remove(at: indexPath.row)
        //セルを削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}
