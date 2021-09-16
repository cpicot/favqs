//
//  AppDelegate.swift
//  favqs
//
//  Created by Clement Picot on 16/09/2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupAppCoordinator()

        return true
    }
}

private extension AppDelegate {
    func setupAppCoordinator() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        self.appCoordinator = AppCoordinator(window: window)
        appCoordinator.launch()
    }
}
