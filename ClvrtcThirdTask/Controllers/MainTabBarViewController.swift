//
//  MainTabBarViewController.swift
//  ClvrtcThirdTask
//
//  Created by Artyom Beldeiko on 19.12.22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        setupTabBar()
    }

    private func setupViewControllers() {
        let contactsVC = UINavigationController(rootViewController: ContactsViewController())
        let favouriteVC = UINavigationController(rootViewController: FavouriteContactsViewController())

        contactsVC.tabBarItem.image = UIImage(systemName: "person.2")
        contactsVC.tabBarItem.selectedImage = UIImage(systemName: "person.2.fill")
        favouriteVC.tabBarItem.image = UIImage(systemName: "heart.circle")
        favouriteVC.tabBarItem.selectedImage = UIImage(systemName: "heart.circle.fill")

        setViewControllers([contactsVC, favouriteVC], animated: true)
    }

    private func setupTabBar() {
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
    }
}
