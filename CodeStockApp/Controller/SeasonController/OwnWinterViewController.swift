//
//  OwnWinterViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/01.
//

import Foundation
import UIKit
import RealmSwift

class OwnWinterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var wintercodestockSecondList: [WinterCodeStockSecondDataModel] = []
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
    
    func setcodestockData() {
        let result = realm.objects(WinterCodeStockSecondDataModel.self).sorted(byKeyPath: "recordDate", ascending: false)
        wintercodestockSecondList = Array(result)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wintercodestockSecondList.count
    }
    
    private let formatter = DateFormatter()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wintercell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let wintercodestockDataModel: WinterCodeStockSecondDataModel = wintercodestockSecondList[indexPath.row]
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
        
        //セル生成時にindexPathを渡しておく
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
        wintercell.backgroundColor = UIColor(red: 255/255, green: 227/255, blue: 254/255, alpha: 1.0)
        return wintercell
    }
    // Cell が選択された場合
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//新しく投稿する際のdelegate
extension OwnWinterViewController: PostWinterSecondDelegate {
    func newwinterSecondPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
}

//編集のためのdelegate
extension OwnWinterViewController: MainTableViewCellDelegate {
    func giveAction(at indexPath: IndexPath) {
        print("sss")
    }
    
    func giveEditAction(at indexPath: IndexPath) {
        print("sss")
    }
}
