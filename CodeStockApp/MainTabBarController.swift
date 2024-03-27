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
        var netstoryboard = UIStoryboard(name: "NetView", bundle: nil)
        let netVC = netstoryboard.instantiateViewController(withIdentifier: "Net") as! NetViewController
        netVC.tabBarItem = UITabBarItem(title: "Net", image: .none, selectedImage: nil)
        
        var ownstoryboard = UIStoryboard(name: "OwnView", bundle: nil)
        let ownVC = ownstoryboard.instantiateViewController(withIdentifier: "Own") as! OwnViewController
        ownVC.tabBarItem = UITabBarItem(title: "Own", image: .none, selectedImage: nil)
        
        viewControllers = [netVC, ownVC]
    }
}
