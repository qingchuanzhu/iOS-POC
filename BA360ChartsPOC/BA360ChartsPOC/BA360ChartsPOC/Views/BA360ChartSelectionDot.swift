//
//  BA360ChartSelectionDot.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 6/13/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

class BA360ChartSelectionDot: UIView {
    
    var radius:Float = 1 {
        willSet{
            if newValue < 0 {
                fatalError("Trying to set radius less than 0")
            }
        }
    }
    var fillColor:UIColor = UIColor.black
    var borderColor:UIColor = UIColor.black
    var borderWith:Float = 0 {
        willSet{
            if newValue < 0 {
                fatalError("Trying to set radius less than 0")
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
 

}
