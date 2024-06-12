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
   // @IBOutlet var splashView: LottieAnimationView!
        
    @IBOutlet var splashView: UIView!
    @IBOutlet weak var titleLogo: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLogo.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            UIView.animate(withDuration: 2.0, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: []) {
                self.titleLogo.alpha = 1
                self.titleLogo.frame.origin.y += 350
        } completion: { (_) in
            UIView.animate(withDuration: 1) {
                self.titleLogo.alpha = 0.0
            } completion: { _ in
                self.titleLogo.alpha = 0.0
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //2秒後にsplashViewを削除
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            self.splashView.removeFromSuperview()
            
            let vc = MainTabBarController()
            let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController = vc
        }
    }
}
