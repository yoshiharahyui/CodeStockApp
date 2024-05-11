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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wintercell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let wintercodestockDataModel: WinterCodeStockDataModel = wintercodestockList[indexPath.row]
        let imageView = addVC.imageView
        let defaultImage = UIImage(named: "defaultImage")
        wintercell.datelabel.text = "\(wintercodestockDataModel.recordDate)"
        wintercell.datelabel.textColor = .black
        wintercell.memolabel.text = wintercodestockDataModel.memotext
        wintercell.memolabel.textColor = .black
        //if letを使いData?をアンラップし、dataがある時とnilの時で分けた
        let imageData: Data? = nil
        if let imageData = wintercodestockDataModel.imageData {
            wintercell.imageview.image = UIImage(data: wintercodestockDataModel.imageData!)
        } else {
            wintercell.imageview?.image = defaultImage
        }
        //MaintableViewCellのresizedimage()を実行する
        wintercell.resizedimage()
        view.layoutIfNeeded()
        //セルの背景色変更
        wintercell.backgroundColor = UIColor(red: 202/255, green: 237/255, blue: 250/255, alpha: 1.0)
        //セルを選択不可
        wintercell.isUserInteractionEnabled = false
        return wintercell
    }
}

extension WinterViewController: PostWinterDelegate {
    func newwinterPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
    
    
}
