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
        summercell.datelabel.textColor = .black
        summercell.memolabel.text = summercodestockDataModel.memotext
        summercell.memolabel.textColor = .black
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
        summercell.backgroundColor = UIColor(red: 255/255, green: 177/255, blue: 78/255, alpha: 1.0)
        return summercell
    }
}

extension SummerViewController: PostSummerDelegate {
    func newsummerPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
}

extension SummerViewController: MainTableViewCellDelegate {
    func giveEditAction(at indexPath: IndexPath) {
        
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
