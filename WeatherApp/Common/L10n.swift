//
//  L10n.swift
//  WeatherApp
//
//  Created by Jose Cruz on 30/06/2024.
//

import UIKit

extension String {
    func localized(withComment:String = "") -> String {
        return NSLocalizedString(self, comment: withComment)
    }
}
