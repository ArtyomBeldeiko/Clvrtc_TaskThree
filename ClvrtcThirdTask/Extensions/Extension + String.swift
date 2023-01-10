//
//  Extension + String.swift
//  ClvrtcThirdTask
//
//  Created by Artyom Beldeiko on 25.12.22.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}
