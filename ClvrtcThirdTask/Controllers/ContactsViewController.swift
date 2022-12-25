//
//  ContactsViewController.swift
//  ClvrtcThirdTask
//
//  Created by Artyom Beldeiko on 20.12.22.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController {

    let defaults = UserDefaults.standard

    var contacts = [ContactData]()
    var contactStore = CNContactStore()

    private let contactsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let initialLaunchBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var initialLauchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 14
        button.setTitle("Download contacts", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tappedInitialLaunchButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if defaults.bool(forKey: "First launch") == true {
            title = "Contacts"
            contacts = Storage.retrieve("contacts.json", from: .caches, as: [ContactData].self)
            view.addSubview(contactsTableView)
            setupContactsTableView()
            defaults.set(true, forKey: "First launch")
//            let domain = Bundle.main.bundleIdentifier!
//            UserDefaults.standard.removePersistentDomain(forName: domain)
//            UserDefaults.standard.synchronize()
//            print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        } else {
            contactStore.requestAccess(for: .contacts) { [weak self] (success, error) in
                guard let self = self else { return }
                if success {
                    self.title = "Contacts"
                    self.view.addSubview(self.contactsTableView)
                    self.setupContactsTableView()
                    self.view.addSubview(self.initialLaunchBackground)
                    self.view.addSubview(self.initialLauchButton)
                    self.setupInitialLauchView()
                } else {
                    print(error?.localizedDescription as Any)
                }
            }

            defaults.set(true, forKey: "First launch")
        }

        contactsTableView.dataSource = self
        contactsTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contacts = Storage.retrieve("contacts.json", from: .caches, as: [ContactData].self)
        contactsTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        Storage.store(self.contacts, to: .caches, as: "contacts.json")
    }

    private func setupContactsTableView() {
        contactsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contactsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contactsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contactsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setupInitialLauchView() {
        initialLaunchBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        initialLaunchBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        initialLaunchBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        initialLaunchBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        initialLauchButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        initialLauchButton.widthAnchor.constraint(equalToConstant: 220).isActive = true
        initialLauchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        initialLauchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc private func tappedInitialLaunchButton() {
        fetchContacts()
        initialLauchButton.removeFromSuperview()
        initialLaunchBackground.removeFromSuperview()
    }

    private func fetchContacts() {
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)

        DispatchQueue.global().async {
            do {
                try self.contactStore.enumerateContacts(with: request) { contact, _ in
                    let name = contact.givenName
                    let familyName = contact.familyName
                    let number = contact.phoneNumbers.first?.value.stringValue
                    let image = contact.imageData
                    let profileImage = UIImage(data: image!)

                    if let image = profileImage, let number = number {
                        let contactItem = ContactData(givenName: name, familyName: familyName, phoneNumber: number, image: image, isFavourite: false)
                        self.contacts.append(contactItem)
                    }
                }
            } catch let error {
                print("Fetch contact error: \(error)")
            }

            DispatchQueue.main.async {
                self.contactsTableView.reloadData()
            }

            Storage.store(self.contacts, to: .caches, as: "contacts.json")
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier, for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() }

        cell.nameLable.text = contacts[indexPath.row].givenName + " " + contacts[indexPath.row].familyName
        cell.phoneNumberLable.text = contacts[indexPath.row].phoneNumber
        cell.photoImageView.image = contacts[indexPath.row].image
        cell.favouriteButton.isSelected = contacts[indexPath.row].isFavourite
        cell.addToFavouritesCompletion = {
            if cell.favouriteButton.isSelected {
                cell.favouriteButton.isSelected = false
                self.contacts[indexPath.row].isFavourite = false
            } else {
                cell.favouriteButton.isSelected = true
                self.contacts[indexPath.row].isFavourite = true
            }

            Storage.store(self.contacts, to: .caches, as: "contacts.json")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var selectedItem = contacts[indexPath.row]

        let contactDetailVC = ContactDetailViewController()
        contactDetailVC.contactImage.image = selectedItem.image
        contactDetailVC.nameTextField.text = selectedItem.givenName + " " + selectedItem.familyName
        contactDetailVC.phoneNumberTextField.text = selectedItem.phoneNumber
        contactDetailVC.title = selectedItem.givenName + " " + selectedItem.familyName
        contactDetailVC.contactItem = selectedItem

        contactDetailVC.completionHandler = { updatedName, updatedSurname, updatedPhone in
            selectedItem.givenName = updatedName
            selectedItem.familyName = updatedSurname
            selectedItem.phoneNumber = updatedPhone
            self.contacts = self.contacts.map({ $0.image == selectedItem.image ? selectedItem : $0 })
            Storage.store(self.contacts, to: .caches, as: "contacts.json")
        }

        navigationController?.pushViewController(contactDetailVC, animated: true)
    }
}
