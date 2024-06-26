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
    var fallvc: FallViewController!
    var wintervc: WinterViewController!
    var pagingvc = PagingViewController()
    var indexitem: PagingIndexItem!
    
    
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
        let Summervc = summerstoryboard.instantiateViewController(withIdentifier: "Summer") as! SummerViewController
        summervc = Summervc
        
        let fallstoryboard = UIStoryboard(name: "FallView", bundle: nil)
        let Fallvc = fallstoryboard.instantiateViewController(withIdentifier: "Fall") as! FallViewController
        fallvc = Fallvc
        
        let winterstoryboard = UIStoryboard(name: "WinterView", bundle: nil)
        let Wintervc = winterstoryboard.instantiateViewController(withIdentifier: "Winter") as! WinterViewController
        wintervc = Wintervc
        
        SpringVC.title = "Spring"
        Summervc.title = "Summer"
        Fallvc.title = "Fall"
        Wintervc.title = "Winter"
        
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
        pagingViewController.delegate = self
        
        //インスタンスをChildViewControllerに入れる
        addChild(pagingViewController)
                view.addSubview(pagingViewController.view)
                pagingViewController.didMove(toParent: self)
                pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

                pagingViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                pagingViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
                pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pagingvc = pagingViewController
    }
    
    @objc func tapSettingButton(sender: UIButton) {
        var addvc = AddViewController()
        let addstoryboard = UIStoryboard(name: "AddView", bundle: nil)
        let AddVC = addstoryboard.instantiateViewController(withIdentifier: "addview") as! AddViewController
        AddVC.getindex = indexitem
        addvc = AddVC
        //表示しているaddvcに季節のdelegateを設定する
        addvc.delegate = springvc
        addvc.summerdelegate = summervc
        addvc.falldelegate = fallvc
        addvc.winterdelegate = wintervc
        addvc.modalPresentationStyle = .formSheet
        present(addvc, animated: true, completion: nil)
    }
}

extension NetViewController: PagingViewControllerDelegate {
    func pagingViewController(
            _ pagingViewController: PagingViewController,
            didScrollToItem pagingItem: PagingItem,
            startingViewController: UIViewController?,
            destinationViewController: UIViewController,
            transitionSuccessful: Bool) {
            //indexを取得
            guard let indexItem = pagingViewController.state.currentPagingItem as? PagingIndexItem else {
            return }
            //クラス直下のindexitemに代入して保持する
                indexitem = indexItem
    }
}
