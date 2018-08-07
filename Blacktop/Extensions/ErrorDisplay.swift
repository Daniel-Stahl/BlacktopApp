//
//  ErrorDisplay.swift
//  Blacktop
//
//  Created by Daniel Stahl on 8/7/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .invalidEmail, .missingEmail:
            return "Please enter a valid email"
        case .userNotFound:
            return "No such user exists"
        case .wrongPassword:
            return "Invalid email or password"
        default:
            return "Unknown error occurred"
        }
    }
}
