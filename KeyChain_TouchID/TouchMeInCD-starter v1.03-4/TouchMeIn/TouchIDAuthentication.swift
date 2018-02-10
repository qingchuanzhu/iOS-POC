//
//  TouchIDAuthentication.swift
//  TouchMeIn
//
//  Created by Qingchuan Zhu on 2/9/18.
//  Copyright © 2018 iT Guy Technologies. All rights reserved.
//

import UIKit
import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

class BiometricIDAuth {
    let context = LAContext() //authentication context, which is the main player in Local Authentication
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func biometricType() -> BiometricType {
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        }
    }
}
