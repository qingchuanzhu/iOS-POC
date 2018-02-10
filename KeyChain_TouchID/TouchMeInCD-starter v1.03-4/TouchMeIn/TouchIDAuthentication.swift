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
    //the reason the application is requesting authentication. It will display to the user on the presented dialog.
    var loginReason = "Logging in with Touch ID"
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
    
    func authenticateUser(completion: @escaping () -> Void) {
        //use canEvaluatePolicy() to check whether the device is capable of biometric authentication.
        guard canEvaluatePolicy() else {
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
            // 4
            if success {
                DispatchQueue.main.async {
                    // User authenticated successfully, take appropriate action
                    // By default, the policy evaluation happens on a private thread, so your code jumps back to the main thread so it can update the UI. 
                    completion()
                }
            } else {
                // TODO: deal with LAError cases
            }
        }
        
    }
}
