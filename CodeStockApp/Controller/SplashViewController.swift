//
//  SplashViewController.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/06/10.
//

import Foundation
import UIKit
import Lottie

class SplashViewController: UIViewController {
    private let splashView: UIView = {
            let view = UIView()
            view.backgroundColor = .blue // 背景色を設定
            return view
        }()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(splashView)
            splashView.frame = view.bounds // 画面全体を覆う
            
            // 2秒後にsplashViewを削除
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.splashView.removeFromSuperview()
                
                // MainTabBarControllerに遷移
                    //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    //let mainTabBarController = storyboard.instantiateInitialViewController() as? UITabBarController
                
                let vc = MainTabBarController()
                vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
            }
        }
}
