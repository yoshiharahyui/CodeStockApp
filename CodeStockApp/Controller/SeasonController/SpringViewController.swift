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
    
    private var codestockList: [CodeStockDataModel] = []
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
        let result = realm.objects(CodeStockDataModel.self).sorted(byKeyPath: "recordDate", ascending: false)
        codestockList = Array(result)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codestockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageView = addVC.imageView
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        let codestockDataModel: CodeStockDataModel = codestockList[indexPath.row]
        let defaultImage = UIImage(named: "defaultImage")
        
        cell.datelabel.text = "\(codestockDataModel.recordDate)"
        cell.datelabel.textColor = .black
        cell.memolabel.text = codestockDataModel.memotext
        cell.memolabel.textColor = .black
        
        //if letを使いData?をアンラップし、dataがある時とnilの時で分けた
        let imageData: Data? = nil
        if let imageData = codestockDataModel.imageData {
            cell.imageview.image = UIImage(data: codestockDataModel.imageData!)
        } else {
            cell.imageView?.image = defaultImage
        }
        
        cell.resizedimage()
        view.layoutIfNeeded()
        //セルの背景色変更
        cell.backgroundColor = UIColor(red: 255/255, green: 227/255, blue: 254/255, alpha: 1.0)
        //セルを選択不可
        cell.isUserInteractionEnabled = false
        return cell
    }
}

extension SpringViewController: PostDelegate {
    func newPost(memotext: String) {
        setcodestockData()
        tableView.reloadData()
    }
}
