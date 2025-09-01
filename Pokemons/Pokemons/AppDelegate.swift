//
//  AppDelegate.swift
//  Pokemons
//
//  Created by tunc on 15.07.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // VIPER: Root'u Router üzerinden kur, Presenter injection garanti olsun
    let homeVC = HomeRouter.buildModule()
    let navController = UINavigationController(rootViewController: homeVC)
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = navController
    window?.makeKeyAndVisible()
    
    return true
  }
}
