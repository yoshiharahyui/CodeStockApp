//
//  NetViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/03/26.
//

import Foundation
import UIKit

class NetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CodeStock"
        //navigationBarの背景色の設定
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        //背景色
        appearance.backgroundColor = UIColor.black
        //タイトル文字の色
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
