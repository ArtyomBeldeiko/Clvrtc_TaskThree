//
//  FavouriteContactsViewController.swift
//  ClvrtcThirdTask
//
//  Created by Artyom Beldeiko on 20.12.22.
//

import UIKit

class FavouriteContactsViewController: UIViewController {
        
    var contacts = [ContactData]()
    var favouriteContacts: [ContactData]?
    
    private let favouritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavouriteContactsTableViewCell.self, forCellReuseIdentifier: FavouriteContactsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favourites".localized()
        
        view.addSubview(favouritesTableView)
        setupFavouritesTableView()
        
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contacts = Storage.retrieve("contacts.json", from: .caches, as: [ContactData].self)
        favouriteContacts = contacts.filter({ $0.isFavourite })
        favouritesTableView.reloadData()
    }
    
    private func setupFavouritesTableView() {
        favouritesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        favouritesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        favouritesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        favouritesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FavouriteContactsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteContacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteContactsTableViewCell.identifier, for: indexPath) as? FavouriteContactsTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        if let contacts = favouriteContacts {
            cell.nameLable.text = contacts[indexPath.row].givenName + " " + contacts[indexPath.row].familyName
            cell.phoneNumberLable.text = contacts[indexPath.row].phoneNumber
            cell.photoImageView.image = contacts[indexPath.row].image
        }
        return cell
    }
}
