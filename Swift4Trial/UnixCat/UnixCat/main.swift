//
//  main.swift
//  UnixCat
//
//  Created by Qingchuan Zhu on 8/23/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import Foundation

let standardIn = AnySequence{
    return AnyIterator{
        readLine()
    }
}

let numberedStdIn = standardIn.enumerated()
for (i,line) in numberedStdIn{
    print("\(i+1): \(line)")
}
