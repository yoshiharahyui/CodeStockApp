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
        var netstoryboard = UIStoryboard(name: "Net", bundle: nil)
        let netVC = storyboard?.instantiateViewController(withIdentifier: "NetViewController") as! NetViewController
        
        var ownstoryboard = UIStoryboard(name: "Own", bundle: nil)
        let ownVC = storyboard?.instantiateViewController(withIdentifier: "OwnViewController") as! OwnViewController
    }
}
