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

class BiometricIDAuth {
    let context = LAContext() //authentication context, which is the main player in Local Authentication
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
