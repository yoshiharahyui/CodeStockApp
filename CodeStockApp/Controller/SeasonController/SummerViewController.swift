//
//  SummerViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/03/30.
//

import Foundation
import UIKit
import RealmSwift

class SummerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var summercodestockList: [SummerCodeStockDataModel] = []
    
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
        let realm = try! Realm()
        let result = realm.objects(SummerCodeStockDataModel.self).sorted(byKeyPath: "recordDate", ascending: false)
        summercodestockList = Array(result)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summercodestockList.count
    }
    private let formatter = DateFormatter()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let summercell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let summercodestockDataModel: SummerCodeStockDataModel = summercodestockList[indexPath.row]
        let defaultImage = UIImage(named: "defaultImage")
        //dateFormatterの設定
        formatter.locale = Locale(identifier: "defaultImage")
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
        //セルのタップを不可能にする
        summercell.selectionStyle = UITableViewCell.SelectionStyle.none
        return summercell
    }
    // Cell が選択された場合
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        }
}

extension SummerViewController: PostSummerDelegate {
    func newsummerPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
}
extension SummerViewController: SummerUpdateDelegate {
    func summerupdatePost(summerupdateData: SummerCodeStockDataModel) {
        setcodestockData()
        tableView.reloadData()
    }
    
    
}
//アラートを押してカスタムセルを削除するメソッド
extension SummerViewController: MainTableViewCellDelegate {
    func giveEditAction(at indexPath: IndexPath) {
        let targetData = summercodestockList[indexPath.row]
        //Editボタン押した時の処理
        let editstoryboard = UIStoryboard(name: "EditView", bundle: nil)
        let EditVC = editstoryboard.instantiateViewController(withIdentifier: "editview") as! EditViewController
        var editvc = EditViewController()
        EditVC.summerupdatedelegate = self
        EditVC.summerconfigure(summerdata: targetData)
        editvc = EditVC
        editvc.modalPresentationStyle = .formSheet
        present(editvc, animated: true, completion: nil)
    }
    
    func giveAction(at indexPath: IndexPath) {
        //IndexPathをもとに削除するオブジェクトを特定
        let target = summercodestockList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(target)
        }
        //配列からそのオブジェクトを削除
        summercodestockList.remove(at: indexPath.row)
        //セルを削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}
