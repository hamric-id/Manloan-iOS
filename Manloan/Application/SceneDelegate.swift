//
//  SceneDelegate.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let viewController = AppContainer.shared.resolveViewController(LoanListViewController.self)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
