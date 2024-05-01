//
//  NetViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/03/26.
//

import Foundation
import UIKit
import Parchment

class NetViewController: UIViewController {
    
    var button: UIBarButtonItem!
    var springvc: SpringViewController!
    var summervc: SummerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CodeStock"
        //navigationBarの背景色の設定
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        configureparchment()
        
        //ダークモードの設定
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.overrideUserInterfaceStyle = .dark
        
        button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapSettingButton))
                navigationItem.rightBarButtonItem = button
    }
    
    //Parchmentを使ったタブ作成
    func configureparchment() {
        
        let springstoryboard = UIStoryboard(name: "SpringView", bundle: nil)
        let SpringVC = springstoryboard.instantiateViewController(withIdentifier: "Spring") as! SpringViewController
        springvc = SpringVC
        
        let summerstoryboard = UIStoryboard(name: "SummerView", bundle: nil)
        let summervc = summerstoryboard.instantiateViewController(withIdentifier: "Summer") as! SummerViewController
        
        let fallstoryboard = UIStoryboard(name: "FallView", bundle: nil)
        let fallvc = fallstoryboard.instantiateViewController(withIdentifier: "Fall") as! FallViewController
        
        let winterstoryboard = UIStoryboard(name: "WinterView", bundle: nil)
        let wintervc = winterstoryboard.instantiateViewController(withIdentifier: "Winter") as! WinterViewController
        
        SpringVC.title = "Spring"
        summervc.title = "Summer"
        fallvc.title = "Fall"
        wintervc.title = "Winter"
        
        //インスタンスを作成して4つのVCを配列に入れ込む
        let pagingViewController = PagingViewController(viewControllers: [ springvc, summervc, fallvc, wintervc ])
        //メニューアイテムの色設定
        pagingViewController.menuItemSpacing = -40
        pagingViewController.indicatorColor = .white
        pagingViewController.indicatorOptions = .visible(height: 4, zIndex: Int.max, spacing: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), insets: UIEdgeInsets())
        pagingViewController.borderColor = .white
        pagingViewController.menuBackgroundColor = .black
        pagingViewController.textColor = .white
        pagingViewController.selectedTextColor = .darkGray
        
        //インスタンスをChildViewControllerに入れる
        addChild(pagingViewController)
                view.addSubview(pagingViewController.view)
                pagingViewController.didMove(toParent: self)
                pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

                pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
                pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    @objc func tapSettingButton(sender: UIButton) {
        var addvc: AddViewController!
        let addstoryboard = UIStoryboard(name: "AddView", bundle: nil)
        let AddVC = addstoryboard.instantiateViewController(withIdentifier: "addview") as! AddViewController
        addvc = AddVC
        addvc.delegate = springvc
        addvc.modalPresentationStyle = .formSheet
        present(addvc, animated: true, completion: nil)
    }
}
