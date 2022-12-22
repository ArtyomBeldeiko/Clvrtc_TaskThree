//
//  ContactsViewController.swift
//  ClvrtcThirdTask
//
//  Created by Artyom Beldeiko on 20.12.22.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController {

    var contacts = [ContactData]()
    var contactStore = CNContactStore()

    private let contactsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(contactsTableView)

        setupContactsTableView()

        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success {
                print("Authorization is successfull")
            } else {
                print(error?.localizedDescription as Any)
            }
        }

        fetchContacts()

        contactsTableView.dataSource = self
        contactsTableView.delegate = self
    }

    private func setupContactsTableView() {
        contactsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contactsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contactsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contactsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
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
        }
    }
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier, for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() }

        cell.nameLable.text = contacts[indexPath.row].givenName + " " + contacts[indexPath.row].familyName
        cell.phoneNumberLable.text = contacts[indexPath.row].phoneNumber
        cell.photoImageView.image = contacts[indexPath.row].image
        return cell
    }
}
