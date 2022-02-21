//
//  SceneDelegate.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        setupNavigationViewController(window: window)
    }
    
    private func setupNavigationViewController(window: UIWindow?) {
        let tabBarVC = UITabBarController()
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass"))
        tabBarVC.setViewControllers([UINavigationController(rootViewController: searchVC)], animated: true)
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }
}

