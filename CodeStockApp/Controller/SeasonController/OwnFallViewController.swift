//
//  OwnFallViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/01.
//

import Foundation
import UIKit

class OwnFallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //セルの登録
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        cell.datelabel.text = "2024/05/03"
        cell.datelabel.textColor = .black
        cell.imageview.image = UIImage(systemName: "swift")
        cell.memolabel.text = "asdcndifnaofaewfnkasf"
        cell.memolabel.textColor = .black
        //セルの背景色変更
        cell.backgroundColor = UIColor(red: 203/255, green: 155/255, blue: 97/255, alpha: 1.0)
        //セルを選択不可
        cell.isUserInteractionEnabled = false
        return cell
    }
}
