//
//  TabBarViewController.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

import UIKit

class TabBarViewController: UITabBarController {
    // Display tabs
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            let appearanceUINav = UINavigationBarAppearance()
            let appearanceUITab = UITabBarAppearance()
            UINavigationBar.appearance().standardAppearance = appearanceUINav
            UINavigationBar.appearance().scrollEdgeAppearance = appearanceUINav
            UITabBar.appearance().standardAppearance = appearanceUITab
            UITabBar.appearance().scrollEdgeAppearance = appearanceUITab
        } else {
            // Fallback on earlier versions
        }
        navigationController?.navigationBar.barTintColor = UIColor.white
        tabBarController?.tabBar.barTintColor = UIColor.white
        // Background transparency
        UITabBar.appearance().backgroundImage = UIImage()
        // Boundary transparency
        UITabBar.appearance().shadowImage = UIImage()
        // Change color
        UITabBar.appearance().barTintColor = UIColor.white
        setUpControllers()
    }
    // Controller settings
    private func setUpControllers() {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else {
            AuthManager.shared.signOut { _ in }
            return
        }
        let home = HomeViewController()
        home.title = "Home"
        let profile = ProfileViewController(currentEmail: currentUserEmail)
        profile.title = "Profile"
        let various = VariousViewController()
        various.title = "Various"
        home.navigationItem.largeTitleDisplayMode = .always
        profile.navigationItem.largeTitleDisplayMode = .always
        various.navigationItem.largeTitleDisplayMode = .always
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: profile)
        let nav3 = UINavigationController(rootViewController: various)
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "antenna.radiowaves.left.and.right.circle.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "figure.wave.circle.fill"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Various", image: UIImage(systemName: "personalhotspot.circle.fill"), tag: 3)
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
}
