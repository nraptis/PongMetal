//
//  SceneDelegate.swift
//  Pong
//
//  Created by Tiger Nixon on 5/4/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let scene = PongScene()
        let graphics = Graphics(delegate: scene,
                                width: Float(UIScreen.main.bounds.width),
                                height: Float(UIScreen.main.bounds.height))
        window?.rootViewController = graphics.metalViewController
        graphics.metalViewController.load()
        window?.makeKeyAndVisible()
    }
}
