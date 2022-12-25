//
//  ContactDetailViewController.swift
//  ClvrtcThirdTask
//
//  Created by Artyom Beldeiko on 22.12.22.
//

import UIKit
import Foundation

class ContactDetailViewController: UIViewController {

    var contactItem: ContactData!
    var completionHandler: ((String, String, String) -> Void)?

    lazy var contactImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.text = "Name and surname"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .thin)
        label.text = "Phone number"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .darkGray
        textField.font = .systemFont(ofSize: 20, weight: .medium)
        textField.isUserInteractionEnabled = false
        textField.autocorrectionType = .no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .darkGray
        textField.font = .systemFont(ofSize: 20, weight: .medium)
        textField.isUserInteractionEnabled = false
        textField.autocorrectionType = .no
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setViews()
        setConstraints()
        configureNavBar()

        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        contactImage.layer.cornerRadius = contactImage.frame.width / 2
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        completionHandler?(contactItem.givenName, contactItem.familyName, contactItem.phoneNumber)
    }

    private func setViews() {
        self.view.addSubview(contactImage)
        self.view.addSubview(nameLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(phoneNumberLabel)
        self.view.addSubview(phoneNumberTextField)
    }

    private func configureNavBar() {
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(clickedEditButton))
        self.navigationItem.rightBarButtonItem = editButton
    }

    private func setConstraints() {
        let contactImageContraints = [
            contactImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            contactImage.heightAnchor.constraint(equalToConstant: 90),
            contactImage.widthAnchor.constraint(equalToConstant: 90),
            contactImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        let nameLabelContraints = [
            nameLabel.topAnchor.constraint(equalTo: contactImage.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]

        let nameTextFieldContraints = [
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]

        let phoneNumberLabelConstraints = [
            phoneNumberLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor)
        ]

        let phoneNumberTextField = [
            phoneNumberTextField.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 5),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: phoneNumberLabel.leadingAnchor),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]

        NSLayoutConstraint.activate(contactImageContraints)
        NSLayoutConstraint.activate(nameLabelContraints)
        NSLayoutConstraint.activate(nameTextFieldContraints)
        NSLayoutConstraint.activate(phoneNumberLabelConstraints)
        NSLayoutConstraint.activate(phoneNumberTextField)
    }

    @objc private func clickedEditButton() {
        if navigationItem.rightBarButtonItem?.title == "Edit" {
            navigationItem.rightBarButtonItem?.title = "Save"
            nameTextField.isUserInteractionEnabled = true
            phoneNumberTextField.isUserInteractionEnabled = true
            nameTextField.textColor = .red
            phoneNumberTextField.textColor = .red
            nameTextField.borderStyle = .roundedRect
            phoneNumberTextField.borderStyle = .roundedRect
        } else {
            navigationItem.rightBarButtonItem?.title = "Edit"
            nameTextField.isUserInteractionEnabled = false
            phoneNumberTextField.isUserInteractionEnabled = false
            nameTextField.textColor = .darkGray
            phoneNumberTextField.textColor = .darkGray
            nameTextField.borderStyle = .none
            phoneNumberTextField.borderStyle = .none

            self.view.endEditing(true)

            let nameSurnameValues = nameTextField.text?.components(separatedBy: .whitespaces)

            if let nameAndSurname = nameSurnameValues, let phoneNumber = phoneNumberTextField.text {
                contactItem?.givenName = nameAndSurname[0]
                contactItem?.familyName = nameAndSurname[1]
                contactItem?.phoneNumber = phoneNumber
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension ContactDetailViewController: UITextFieldDelegate {

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
