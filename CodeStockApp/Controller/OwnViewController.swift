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
            
            //インスタンスを作成して4つのVCを配列に入れ込む
            let pagingViewController = PagingViewController(viewControllers: [ ownspringvc, ownsummervc, ownfallvc, ownwintervc ])
            
            //メニューアイテムの色設定
            pagingViewController.menuItemSpacing = -40
            pagingViewController.indicatorColor = .white
            pagingViewController.indicatorOptions = .visible(height: 4, zIndex: Int.max, spacing: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), insets: UIEdgeInsets())
            pagingViewController.borderColor = .white
            pagingViewController.menuBackgroundColor = .black
            pagingViewController.textColor = .white
            pagingViewController.selectedTextColor = .darkGray
            
            //インスタンスをchildViewControllerに入れる
            addChild(pagingViewController)
                    view.addSubview(pagingViewController.view)
                    pagingViewController.didMove(toParent: self)
                    pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
                    pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                    pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
                    pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                    pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
}

