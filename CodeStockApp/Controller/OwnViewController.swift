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
    
    var button: UIBarButtonItem!
    var ownspringvc: OwnSpringViewController!
    var ownsummervc: OwnSummerViewController!
    var ownfallvc: OwnFallViewController!
    var ownwintervc: OwnWinterViewController!
    var pagingvc = PagingViewController()
    var indexitem: PagingIndexItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CodeStock"
        //navigationBarの背景色の設定
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
//        //背景色
//        appearance.backgroundColor = UIColor.black
//        //タイトル文字の色
//        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
        private func configureparchment() {
            let ownspringstoryboard = UIStoryboard(name: "OwnSpringView", bundle: nil)
            let Ownspringvc = ownspringstoryboard.instantiateViewController(withIdentifier: "OwnSpring") as! OwnSpringViewController
            ownspringvc = Ownspringvc
            
            let ownsummerstoryboard = UIStoryboard(name: "OwnSummerView", bundle: nil)
            let Ownsummervc = ownsummerstoryboard.instantiateViewController(withIdentifier: "OwnSummer") as! OwnSummerViewController
            ownsummervc = Ownsummervc
            
            let ownfallstoryboard = UIStoryboard(name: "OwnFallView", bundle: nil)
            let Ownfallvc = ownfallstoryboard.instantiateViewController(withIdentifier: "OwnFall") as! OwnFallViewController
            ownfallvc = Ownfallvc
            
            let ownwinterstoryboard = UIStoryboard(name: "OwnWinterView", bundle: nil)
            let Ownwintervc = ownwinterstoryboard.instantiateViewController(withIdentifier: "OwnWinter") as! OwnWinterViewController
            ownwintervc = Ownwintervc
            
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
    
    @objc func tapSettingButton(sender: UIButton) {
        var addsecondvc = AddSecondViewController()
        let addsecondstoryboard = UIStoryboard(name: "AddSecondView", bundle: nil)
        let AddSecondVC = addsecondstoryboard.instantiateViewController(withIdentifier: "addsecondview") as! AddSecondViewController
        AddSecondVC.getsecondindex = indexitem
        addsecondvc = AddSecondVC
        //表示しているaddvcに季節のdelegateを設定する
        addsecondvc.springseconddelegate = ownspringvc
        addsecondvc.summerseconddelegate = ownsummervc
        //addvc.falldelegate = fallvc
        //addvc.winterdelegate = wintervc
        addsecondvc.modalPresentationStyle = .formSheet
        present(addsecondvc, animated: true, completion: nil)
    }
}

