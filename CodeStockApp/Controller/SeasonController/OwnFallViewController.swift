//
//  OwnFallViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/01.
//

import Foundation
import UIKit
import RealmSwift

class OwnFallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var fallcodestockSecondList: [FallCodeStockSecondDataModel] = []
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
    
    func setcodestockData() {
        let result = realm.objects(FallCodeStockSecondDataModel.self).sorted(byKeyPath: "recordDate", ascending: false)
        fallcodestockSecondList = Array(result)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fallcodestockSecondList.count
    }
    
    private let formatter = DateFormatter()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fallcell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let fallcodestockDataModel: FallCodeStockSecondDataModel = fallcodestockSecondList[indexPath.row]
        let defaultImage = UIImage(named: "defaultImage")
        
        //dateFormatterの設定
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = formatter.string(from: fallcodestockDataModel.recordDate)
        fallcell.datelabel.text = "\(date)"
        fallcell.datelabel.textColor = .white
        fallcell.memolabel.text = fallcodestockDataModel.memotext
        fallcell.memolabel.textColor = .white
        fallcell.delegate = self
        
        //セル生成時にindexPathを渡しておく
        fallcell.indexPath = indexPath
        
        //if letを使いData?をアンラップし、dataがある時とnilの時で分けた
        if fallcodestockDataModel.imageData != nil {
            fallcell.imageview.image = UIImage(data: fallcodestockDataModel.imageData!)
        } else {
            fallcell.imageview?.image = defaultImage
        }
        //MaintableViewCellのresizedimage()を実行する
        fallcell.resizedimage()
        view.layoutIfNeeded()
        //セルの背景色変更
        fallcell.backgroundColor = .systemGray6
        //セルのタップを不可能にする
        fallcell.selectionStyle = UITableViewCell.SelectionStyle.none
        return fallcell
    }
    // Cell が選択された場合
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//新しく投稿する際のdelegate
extension OwnFallViewController: PostFallSecondDelegate {
    func newfallSecondPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
}
//編集のためのdelegate
extension OwnFallViewController: FallSecondUpdateDelegate {
    func fallsecondupdatePost(secondupdateData: FallCodeStockSecondDataModel) {
        setcodestockData()
        tableView.reloadData()
    }
}

extension OwnFallViewController: MainTableViewCellDelegate {
    func giveEditAction(at indexPath: IndexPath) {
        let targetData = fallcodestockSecondList[indexPath.row]
        //Editボタン押した時の処理
        let editsecondstoryboard = UIStoryboard(name: "EditSecondView", bundle: nil)
        let EditSVC = editsecondstoryboard.instantiateViewController(withIdentifier: "editsecondview") as! EditSecondViewController
        //表示しているインスタンス
        var editsvc = EditSecondViewController()
        EditSVC.fallsecondupdatedelegate = self
        EditSVC.fallconfigure(falldata: targetData)
        editsvc = EditSVC
        editsvc.modalPresentationStyle = .formSheet
        present(editsvc, animated: true, completion: nil)
    }
    
    func giveAction(at indexPath: IndexPath) {
        //IndexPathをもとに削除するオブジェクトを特定
        let target = fallcodestockSecondList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(target)
        }
        //配列からそのオブジェクトを削除
        fallcodestockSecondList.remove(at: indexPath.row)
        //セルを削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}
