//
//  MainTabBarController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/03/26.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    func configureViewControllers() {
        let netstoryboard = UIStoryboard(name: "NetView", bundle: nil)
        let netvc = netstoryboard.instantiateViewController(withIdentifier: "Net") as! NetViewController
        //naviationControllerに管理下にNetViewControllerのインスタンスをおく
        let navigationController = UINavigationController(rootViewController: netvc)
        //ネット用タブの設定
        navigationController.tabBarItem = UITabBarItem(title: "Net", image: .none, selectedImage: nil)
        
        let ownstoryboard = UIStoryboard(name: "OwnView", bundle: nil)
        let ownvc = ownstoryboard.instantiateViewController(withIdentifier: "Own") as! OwnViewController
        //naviationControllerに管理下にOwnViewControllerのインスタンスをおく
        let navigationController2 = UINavigationController(rootViewController: ownvc)
        //自分用タブの設定
        navigationController2.tabBarItem = UITabBarItem(title: "Own", image: .none, selectedImage: nil)
        
        viewControllers = [navigationController, navigationController2]
    }
}
