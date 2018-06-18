//
//  CTView.swift
//  CoreTextMagazine
//
//  Created by Qingchuan Zhu on 6/18/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit
import CoreText

class CTView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        // Flip the coordinate system, basically performs a view transform
        context.textMatrix = .identity // The identity transform
        context.translateBy(x: 0, y: bounds.size.height) // change the origin of the coordinate system
        context.scaleBy(x: 1.0, y: -1.0)
        
        let path = CGMutablePath()
        path.addRect(bounds)
        let attrString = NSAttributedString(string: "Hello World")
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        // Core text uses a Y-flipped coordinate system
        CTFrameDraw(frame, context)
    }
}
