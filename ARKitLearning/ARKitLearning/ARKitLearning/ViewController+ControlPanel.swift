//
//  ViewController+ControlPanel.swift
//  ARKitLearning
//
//  Created by Qingchuan Zhu on 2/18/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import Foundation
import UIKit
import ARKit

extension ViewController{
    @objc func switchToggled() {
        if controlPanelSwitch.isOn {
            self.addControlPanel()
        } else {
            self.hideControlPanel()
        }
    }
    
    func addControlPanel() {
        self.controlPanelView.isHidden = false
        self.view.bringSubview(toFront: self.controlPanelView)
    }
    
    func hideControlPanel() {
        self.controlPanelView.isHidden = true
        self.applyConfigureChanges()
    }
    
    func applyConfigureChanges() {
        
    }
    
    @objc func planeDetectionSwitchToggled() {
        if planeDetectionSwitch.isOn {
            self.enablePlaneDetection()
        } else {
            self.disablePlaneDetection()
        }
    }
    
    func enablePlaneDetection() {
        for (_, plane) in self.planes! {
            plane.isHidden = false
        }
        let config = self.sceneView.session.configuration as? ARWorldTrackingConfiguration
        config?.planeDetection = .horizontal
        sceneView.session.run(config!)
    }
    
    func disablePlaneDetection() {
        // Hide all the planes
        for (_, plane) in self.planes! {
            plane.isHidden = true
        }
        // Stop detecting new planes or updating existing ones.
        let config = self.sceneView.session.configuration as? ARWorldTrackingConfiguration
        config?.planeDetection = []
        sceneView.session.run(config!)
    }
    
    func createControlPanelView() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        self.controlPanelView = UIView(frame: CGRect(x: screenWidth / 4, y: screenHeight / 4, width: screenWidth / 2, height: screenHeight / 2))
        self.controlPanelView.layer.cornerRadius = 5
        self.controlPanelView.clipsToBounds = true
        
        let contentView = Bundle.main.loadNibNamed("ControlPanelView", owner: self, options: nil)?.first as! UIView
        contentView.frame = self.controlPanelView.frame
        contentView.frame.origin = CGPoint(x: 0, y: 0)
        self.controlPanelView.addSubview(contentView)
        
        self.controlPanelView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.75)
        self.view.addSubview(self.controlPanelView)
        self.controlPanelView.isHidden = true
    }
}
