//
//  ContactData.swift
//  ClvrtcThirdTask
//
//  Created by Artyom Beldeiko on 21.12.22.
//

import Foundation
import UIKit

struct ContactData: Codable {
    var givenName: String
    var familyName: String
    var phoneNumber: String
    @CodableImage var image: UIImage?
    var isFavourite: Bool
}
