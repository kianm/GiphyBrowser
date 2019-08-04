//
//  UIManager.swift
//  GiphyBrowser
//
//  Created by kian on 6/8/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit

protocol UIManagerType {
    func show(_ state: UIManager.UIManagerState)
    func showFullScreen()
}

final class UIManager: UIManagerType {

    enum UIManagerState: Int {
        case showTrends = 0
        case showSearch = 1
    }

    func show(_ state: UIManagerState) {
        let controller = tabBarController
        controller.selectedIndex = state.rawValue
        UIManager.replaceRootVC(controller)
    }

    func showFullScreen() {
        pushVC(ZoomViewController(), animated: true)
    }

    private lazy var tabBarController: UITabBarController = {
        let trendsViewController = TrendingViewController()
        let searchViewController = SearchViewController()
        trendsViewController.tabBarItem = UITabBarItem(title: "Trends", image: UIImage(named: "tr"), tag: 0)

        let searchTabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "mg"), tag: 1)
        searchViewController.tabBarItem = searchTabBarItem
        searchTabBarItem.isEnabled = false
        let viewControllers = [trendsViewController, searchViewController]
        let controller = UITabBarController()
        controller.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0)}
        return controller
    }()

    public static func presentVC(_ viewController: UIViewController, withNavigation: Bool, animated: Bool) {
        viewController.modalTransitionStyle = .coverVertical
        viewController.view.backgroundColor = UIScheme.backgroundColor
        if withNavigation {
            let nav = UINavigationController(rootViewController: viewController)
            UIApplication.topViewController()?.present(nav, animated: animated)
        } else {
            UIApplication.topViewController()?.present(viewController, animated: animated)
        }
    }

    private func dismissPresentedVC(_ animated: Bool) {
        if let top = UIApplication.topViewController() {
            top.dismiss(animated: animated)
        }
    }

    private static func replaceRootVC(_ viewController: UIViewController?) {
        guard let controller = viewController else {
            return
        }
        controller.view.backgroundColor = UIScheme.backgroundColor
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.isNavigationBarHidden = false
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = UIScheme.backgroundColor
        AppDelegate.window.rootViewController = navigationController
    }

    private func pushVC(_ viewController: UIViewController?, animated: Bool) {
        if let controller = viewController {
            controller.view.backgroundColor = UIScheme.backgroundColor
            UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: animated)
        }
    }
}
