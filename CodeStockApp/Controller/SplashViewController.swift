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
    override func viewDidLoad() {
        super.viewDidLoad()
                //splashView.contentMode = .scaleAspectFit
                //splashView.loopMode = .loop
                //splashView.play()
        //2秒後にsplashViewを削除
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.splashView.removeFromSuperview()
            
            let vc = MainTabBarController()
//            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true)
            let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController = vc
        }
    }
}
