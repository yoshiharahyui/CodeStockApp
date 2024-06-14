//
//  OwnSummerViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/01.
//

import Foundation
import UIKit
import RealmSwift

class OwnSummerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var summercodestockSecondList: [SummerCodeStockSecondDataModel] = []
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
        let result = realm.objects(SummerCodeStockSecondDataModel.self).sorted(byKeyPath: "recordDate", ascending: false)
        summercodestockSecondList = Array(result)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summercodestockSecondList.count
    }
    
    private let formatter = DateFormatter()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let summercell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let summercodestockDataModel: SummerCodeStockSecondDataModel = summercodestockSecondList[indexPath.row]
        let defaultImage = UIImage(named: "defaultImage")
        
        //dateFormatterの設定
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = formatter.string(from: summercodestockDataModel.recordDate)
        summercell.datelabel.text = "\(date)"
        summercell.datelabel.textColor = .white
        summercell.memolabel.text = summercodestockDataModel.memotext
        summercell.memolabel.textColor = .white
        summercell.delegate = self
        
        //セル生成時にindexPathを渡しておく
        summercell.indexPath = indexPath
        
        //if letを使いData?をアンラップし、dataがある時とnilの時で分けた
        if summercodestockDataModel.imageData != nil {
            summercell.imageview.image = UIImage(data: summercodestockDataModel.imageData!)
        } else {
            summercell.imageview?.image = defaultImage
        }
        //MaintableViewCellのresizedimage()を実行する
        summercell.resizedimage()
        view.layoutIfNeeded()
        //セルの背景色変更
        summercell.backgroundColor = .systemGray6
        
        return summercell
    }
    // Cell が選択された場合
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//新しく投稿する際のdelegate
extension OwnSummerViewController: PostSummerSecondDelegate {
    func newsummerSecondPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
}

//編集のためのdelegate
extension OwnSummerViewController: SummerSecondUpdateDelegate {
    func summersecondupdatePost(secondupdateData: SummerCodeStockSecondDataModel) {
        setcodestockData()
        tableView.reloadData()
    }
}

extension OwnSummerViewController: MainTableViewCellDelegate {
    func giveEditAction(at indexPath: IndexPath) {
        let targetData = summercodestockSecondList[indexPath.row]
        //Editボタン押した時の処理
        let editsecondstoryboard = UIStoryboard(name: "EditSecondView", bundle: nil)
        let EditSVC = editsecondstoryboard.instantiateViewController(withIdentifier: "editsecondview") as! EditSecondViewController
        //表示しているインスタンス
        var editsvc = EditSecondViewController()
        EditSVC.summersecondupdatedelegate = self
        EditSVC.summerconfigure(summerdata: targetData)
        editsvc = EditSVC
        editsvc.modalPresentationStyle = .formSheet
        present(editsvc, animated: true, completion: nil)
    }
    
    func giveAction(at indexPath: IndexPath) {
        //IndexPathをもとに削除するオブジェクトを特定
        let target = summercodestockSecondList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(target)
        }
        //配列からそのオブジェクトを削除
        summercodestockSecondList.remove(at: indexPath.row)
        //セルを削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}
