//
//  AppDelegate.swift
//  Yahtzee
//
//  Created by Zvonimir Medak on 16.03.2021..
//

import UIKit
import RxSwift
import RxCocoa

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else {return false}
        let initialViewController = UINavigationController(rootViewController: ViewController(viewModel: ViewModel(buttonStateRelay: BehaviorRelay.init(value: ([1, 1, 1, 1, 1, 1], [false, false, false, false, false, false])), userInteractionSubject: PublishSubject(), rollCounterSubject: PublishSubject())))
        initialViewController.isNavigationBarHidden = true
        window.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        return true
    }


}

