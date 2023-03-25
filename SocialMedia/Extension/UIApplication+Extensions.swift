//
//  UIApplication+Extensions.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/23.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
