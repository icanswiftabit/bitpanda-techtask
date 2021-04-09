//
//  AppFlowController.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import UIKit

final class AppController {

    let rootViewController = UITabBarController()
    private let assetFlowController = AssetFlowController()

    func embedRootViewController(in window: UIWindow) {
        window.rootViewController = configuredRootViewController()
        window.makeKeyAndVisible()
    }
}

private extension AppController {

    func configuredRootViewController() -> UITabBarController {
        rootViewController.tabBar.tintColor = UIColor(named: "PrimaryColor")
        rootViewController.viewControllers = [assetFlowController.rootViewController]
        return rootViewController
    }
}

