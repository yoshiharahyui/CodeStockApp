//
//  FallViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/03/30.
//

import Foundation
import UIKit
import RealmSwift

class FallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var fallcodestockList: [FallCodeStockDataModel] = []
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
        let result = realm.objects(FallCodeStockDataModel.self).sorted(byKeyPath: "recordDate", ascending: false)
        fallcodestockList = Array(result)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fallcodestockList.count
    }
    private let formatter = DateFormatter()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fallcell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let fallcodestockDataModel: FallCodeStockDataModel = fallcodestockList[indexPath.row]
        let defaultImage = UIImage(named: "defaultImage")
        //dateFormatterの設定
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = formatter.string(from: fallcodestockDataModel.recordDate)
        fallcell.datelabel.text = "\(date)"
        fallcell.datelabel.textColor = .black
        fallcell.memolabel.text = fallcodestockDataModel.memotext
        fallcell.memolabel.textColor = .black
        
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
        fallcell.backgroundColor = UIColor(red: 203/255, green: 155/255, blue: 97/255, alpha: 1.0)
        //セルを選択不可
        fallcell.isUserInteractionEnabled = false
        return fallcell
    }
    
}

extension FallViewController: PostFallDelegate {
    func newfallPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
}
