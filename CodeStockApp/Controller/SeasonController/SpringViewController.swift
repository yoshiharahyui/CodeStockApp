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
    
    private var springcodestockList: [SpringCodeStockDataModel] = []
    let addVC = AddViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //セルの登録
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.delegate = self
        addVC.delegate = self
        setcodestockData()
        self.tableView.reloadData()
        //セルの可変
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setcodestockData() {
        let realm = try! Realm()
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
        springcell.springdelegate = self
        
        //if letを使いData?をアンラップし、dataがある時とnilの時で分けた
        //let imageData: Data? = nil
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

extension SpringViewController: PostDelegate {
    func newPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
}
extension SpringViewController: CustomSpringCellDelegate {
    func customSpringCellDelegateDidTapButton(cell: UITableViewCell) {
        
    }
}
