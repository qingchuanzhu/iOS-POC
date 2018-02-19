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
    // MARK: - Panel Control
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
    }

    // MARK: - planeDetection
    @objc func planeDetectionSwitchToggled() {
        if planeDetectionSwitch.isOn {
            self.enablePlaneDetection()
        } else {
            self.disablePlaneDetection()
        }
    }
    
    func enablePlaneDetection() {
        for (_, plane) in self.planes! {
            plane.show()
        }
        let config = self.sceneView.session.configuration as? ARWorldTrackingConfiguration
        config?.planeDetection = .horizontal
        sceneView.session.run(config!)
    }
    
    func disablePlaneDetection() {
        // Hide all the planes
        for (_, plane) in self.planes! {
            plane.hide()
        }
        // Stop detecting new planes or updating existing ones.
        let config = self.sceneView.session.configuration as? ARWorldTrackingConfiguration
        config?.planeDetection = []
        sceneView.session.run(config!)
    }
    
    // MARK: - Erase planes
    @objc func earseAllPlanes() {
        self.planes?.removeAll()
        let session = self.sceneView.session
        for (_, anchor) in self.anchors! {
            session.remove(anchor: anchor)
        }
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
