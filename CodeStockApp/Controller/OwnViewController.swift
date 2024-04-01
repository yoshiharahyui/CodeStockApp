//
//  OwnViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/03/26.
//

import Foundation
import UIKit
import Parchment

class OwnViewController: UIViewController {
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
        
        configureparchment()
    }
    //Parchmentを使ったタブ作成
    func configureparchment() {
        let ownspringstoryboard = UIStoryboard(name: "OwnSpringView", bundle: nil)
        let ownspringvc = ownspringstoryboard.instantiateViewController(withIdentifier: "OwnSpring") as! OwnSpringViewController
        
        let ownsummerstoryboard = UIStoryboard(name: "OwnSummerView", bundle: nil)
        let ownsummervc = ownsummerstoryboard.instantiateViewController(withIdentifier: "OwnSummer") as! OwnSummerViewController
        
        let ownfallstoryboard = UIStoryboard(name: "OwnFallView", bundle: nil)
        let ownfallvc = ownfallstoryboard.instantiateViewController(withIdentifier: "OwnFall") as! OwnFallViewController
        
        let ownwinterstoryboard = UIStoryboard(name: "OwnWinterView", bundle: nil)
        let ownwintervc = ownwinterstoryboard.instantiateViewController(withIdentifier: "OwnWinter") as! OwnWinterViewController
        
        ownspringvc.title = "Spring"
        ownsummervc.title = "Summer"
        ownfallvc.title = "Fall"
        ownwintervc.title = "Winter"
        
        let pagingViewController = PagingViewController(viewControllers: [ ownspringvc, ownsummervc, ownfallvc, ownwintervc ])
        
        
    }
}
