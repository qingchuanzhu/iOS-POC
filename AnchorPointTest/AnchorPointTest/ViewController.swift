//
//  ViewController.swift
//  AnchorPointTest
//
//  Created by Qingchuan Zhu on 7/19/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var testingLabel_default: UILabel!
    @IBOutlet var button1: UIButton!
    @IBOutlet var anchorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.anchorLabel.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        self.anchorLabel.bounds.origin = CGPoint(x: 0, y: anchorLabel.bounds.size.width)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func incrementWidth(_ sender: UIButton) {
        var newFrame:CGRect = self.testingLabel_default.frame
        newFrame.size.width +=  30
        self.testingLabel_default.frame = newFrame
    }
    
    @IBAction func incrementAnchorLabel(_ sender: Any) {
        var newFrame:CGRect = self.anchorLabel.frame
        newFrame.size.width +=  30
        self.anchorLabel.frame = newFrame
    }
}

