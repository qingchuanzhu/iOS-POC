//
//  MyNumber.swift
//  swift4trail
//
//  Created by Qingchuan Zhu on 10/2/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

/*
 This file contains a couple of classes used to test out Limiting @objc Inference in Swift 4
 The GitHub link: https://github.com/apple/swift-evolution/blob/master/proposals/0160-objc-inference.md
 Nagviate to swift4trail-Swift.h to verify the compiler outputs
 */
import UIKit

class MyNumber: NSObject {
    /*
     In Swift3, the following init method will be ported to ObjC with the below signature:
     - (nonnull instancetype)init:(NSInteger)int_ OBJC_DESIGNATED_INITIALIZER;
     
     If we had another init method init(_ double:Double), it will in a similar case, translated to:
     - (nonnull instancetype)init:(double)double_ OBJC_DESIGNATED_INITIALIZER;
     
     Thus we have an overloading of init method in Objective-C, with is INVALID and causes compile error
     
     The fix for this overloading conflicts is to explictly set porting names with @objc as follows:
     @objc(initWithInteger:) init(_ int: Int) { }
     @objc(initWithDouble:) init(_ double: Double) { }
     
     In Swift 4, however, with the Limiting @objc Inference, if we just wirte the following two init, both of them will not be ported to Objective-C:
     init(_ int:Int) { }
     init(_ double:Double) { }
     
     */
    
    init(_ int:Int) {

    }
    init(_ double:Double) {

    }
}

// The declaration is an override of an @objc declaration
class Super {
    @objc func foo() { }
}

class Sub : Super {
    /* inferred @objc */
    override func foo() { }
}
