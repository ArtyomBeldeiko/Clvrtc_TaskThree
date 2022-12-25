//
//  FavouriteContactsTabTableViewCell.swift
//  ClvrtcThirdTask
//
//  Created by Artyom Beldeiko on 25.12.22.
//

import UIKit

class FavouriteContactsTabTableViewCell: UITableViewCell {

    static let identifier = "FavouriteContactsTabTableViewCell"

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

    lazy var favouriteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        contentView.addSubview(favouriteImage)
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

        let favouriteImageConstraints = [
            favouriteImage.heightAnchor.constraint(equalToConstant: 40),
            favouriteImage.widthAnchor.constraint(equalToConstant: 40),
            favouriteImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            favouriteImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]

        NSLayoutConstraint.activate(photoImageViewConstraints)
        NSLayoutConstraint.activate(nameLableConstraints)
        NSLayoutConstraint.activate(phoneNumberLableConstraints)
        NSLayoutConstraint.activate(favouriteImageConstraints)
    }
}
