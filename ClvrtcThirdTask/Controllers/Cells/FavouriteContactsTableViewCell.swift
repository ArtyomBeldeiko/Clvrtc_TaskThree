//
//  FavouriteContactsTableViewCell.swift
//  ClvrtcThirdTask
//
//  Created by Artyom Beldeiko on 25.12.22.
//

import UIKit

class FavouriteContactsTableViewCell: UITableViewCell {

    static let identifier = "FavouriteContactsTableViewCell"

    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = frame.height / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var nameLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var phoneNumberLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLable)
        contentView.addSubview(phoneNumberLable)
    }

    private func setConstraints() {
        let photoImageViewConstraints = [
            photoImageView.heightAnchor.constraint(equalToConstant: 60),
            photoImageView.widthAnchor.constraint(equalToConstant: 60),
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ]

        let nameLableConstraints = [
            nameLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLable.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 15)
        ]

        let phoneNumberLableConstraints = [
            phoneNumberLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 5),
            phoneNumberLable.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            phoneNumberLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]

        NSLayoutConstraint.activate(photoImageViewConstraints)
        NSLayoutConstraint.activate(nameLableConstraints)
        NSLayoutConstraint.activate(phoneNumberLableConstraints)
    }
}
