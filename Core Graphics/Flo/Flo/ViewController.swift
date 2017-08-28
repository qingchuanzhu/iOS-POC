//
//  ViewController.swift
//  Flo
//
//  Created by Qingchuan Zhu on 12/24/16.
//  Copyright © 2016 ProgrammingC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var counterLabel: UILabel!
    
    var isGraphyViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        counterLabel.text = String(counterView.counter)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnPushButton(_ sender: PushButtonView) {
        if sender.isAddButton {
            if counterView.counter < NoOfGlassess {
                counterView.counter += 1
            }
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = "\(counterView.counter)"
        
        // flip to counter view if tapped on button
        if isGraphyViewShowing {
            counterViewTap(nil)
        }
    }

    @IBAction func counterViewTap(_ sender: UITapGestureRecognizer?) {
        if isGraphyViewShowing {
            // hide graph
            UIView.transition(from: graphView, to: counterView, duration: 1.0, options: [UIViewAnimationOptions.transitionFlipFromLeft, UIViewAnimationOptions.showHideTransitionViews], completion: nil)
        } else {
            // show graph
            UIView.transition(from: counterView, to: graphView, duration: 1.0, options: [UIViewAnimationOptions.transitionFlipFromRight, UIViewAnimationOptions.showHideTransitionViews], completion: nil)
        }
        
        isGraphyViewShowing = !isGraphyViewShowing
    }
}

