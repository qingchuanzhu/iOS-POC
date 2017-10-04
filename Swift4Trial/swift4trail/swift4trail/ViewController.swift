//
//  ViewController.swift
//  swift4trail
//
//  Created by Qingchuan Zhu on 10/1/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // test out Strings
        let galaxy = "Milky Way 🐮"
        for char in galaxy {
            print(char)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

