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

        let contactsVC = UINavigationController(rootViewController: ContactsViewController())
        let favouriteVC = UINavigationController(rootViewController: FavouriteContactsViewController())

        contactsVC.tabBarItem.image = UIImage(systemName: "person.2")
        favouriteVC.tabBarItem.image = UIImage(systemName: "heart.circle")

        contactsVC.title = "Contacts"
        favouriteVC.title = "Favourite"

        tabBar.tintColor = .black

        setViewControllers([contactsVC, favouriteVC], animated: true)
    }

}
