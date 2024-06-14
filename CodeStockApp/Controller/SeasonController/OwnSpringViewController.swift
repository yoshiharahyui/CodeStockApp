//
//  OwnSpringViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/01.
//

import Foundation
import UIKit
import RealmSwift

class OwnSpringViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var springcodestockSecondList: [SpringCodeStockSecondDataModel] = []
    let realm = try! Realm()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ScrollButton: UIButton!
    
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
        ScrollButton.layer.cornerRadius = 30
        ScrollButton.addTarget(self, action: #selector(tapScrollButton(_:)), for: UIControl.Event.touchUpInside)
    }
    
    // UIButtonが押された時に呼び出されるメソッド
    @objc func tapScrollButton(_ sender:UIButton) {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    private func setcodestockData() {
        let result = realm.objects(SpringCodeStockSecondDataModel.self).sorted(byKeyPath: "recordDate", ascending: false)
        springcodestockSecondList = Array(result)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return springcodestockSecondList.count
    }
    
    private let formatter = DateFormatter()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let springcell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let springcodestockDataModel: SpringCodeStockSecondDataModel = springcodestockSecondList[indexPath.row]
        let defaultImage = UIImage(named: "defaultImage")

        //dateFormatterの設定
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = formatter.string(from: springcodestockDataModel.recordDate)
        springcell.datelabel.text = "\(date)"
        springcell.datelabel.textColor = .white
        springcell.memolabel.text = springcodestockDataModel.memotext
        springcell.memolabel.textColor = .white
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
        springcell.backgroundColor = .systemGray6
        //セルのタップを不可能にする
        springcell.selectionStyle = UITableViewCell.SelectionStyle.none
        return springcell
    }
    // Cell が選択された場合
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//新しく投稿する際のdelegate
extension OwnSpringViewController: PostSpringSecondDelegate {
    func newSecondPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
}

//編集のためのdelegate
extension OwnSpringViewController: SpringSecondUpdateDelegate {
    func springsecondupdatePost(secondupdateData: SpringCodeStockSecondDataModel) {
        setcodestockData()
        tableView.reloadData()
    }
}


extension OwnSpringViewController: MainTableViewCellDelegate {
    func giveEditAction(at indexPath: IndexPath) {
        let targetData = springcodestockSecondList[indexPath.row]
        //Editボタン押した時の処理
        let editsecondstoryboard = UIStoryboard(name: "EditSecondView", bundle: nil)
        let EditSVC = editsecondstoryboard.instantiateViewController(withIdentifier: "editsecondview") as! EditSecondViewController
        //表示しているインスタンス
        var editsvc = EditSecondViewController()
        EditSVC.springsecondupdatedelegate = self
        EditSVC.configure(data: targetData)
        //EditSVC.updatespringData(data: targetData)
        editsvc = EditSVC
        editsvc.modalPresentationStyle = .formSheet
        present(editsvc, animated: true, completion: nil)
    }
    
    func giveAction(at indexPath: IndexPath) {
        //IndexPathをもとに削除するオブジェクトを特定
        let target = springcodestockSecondList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(target)
        }
        //配列からそのオブジェクトを削除
        springcodestockSecondList.remove(at: indexPath.row)
        //セルを削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}
