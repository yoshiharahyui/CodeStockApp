//
//  SummerViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/03/30.
//

import Foundation
import UIKit

class SummerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        cell.datelabel.text = "2024/04/02"
        cell.imageview.image = UIImage(systemName: "swift")
        cell.memolabel.text = "いい良い良い良いいい"
        cell.backgroundColor = UIColor(red: 255/255, green: 177/255, blue: 78/255, alpha: 1.0)
        cell.isUserInteractionEnabled = false
        return cell
    }
}
