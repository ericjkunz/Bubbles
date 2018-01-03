//
//  AppDelegate.swift
//  Bubble
//
//  Created by Eric Kunz on 9/27/16.
//  Copyright © 2016 Eric Kunz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: BubbleNavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        navigationController = BubbleNavigationController()
        navigationController?.navigationBar.isHidden = true
        let bubbleVC = BubbleCollectionViewController()
        bubbleVC.delegate = navigationController!
        navigationController?.pushViewController(bubbleVC, animated: false)
//        navigationController?.transitioningDelegate = BubbleTransitionDelegate()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }



}

