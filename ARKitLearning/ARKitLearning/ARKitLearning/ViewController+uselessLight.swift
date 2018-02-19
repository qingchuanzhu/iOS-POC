//
//  ViewController+uselessLight.swift
//  ARKitLearning
//
//  Created by Qingchuan Zhu on 2/18/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import Foundation
import SceneKit

extension ViewController{
    func insertSpotLight(position:SCNVector3) {
        let spotLight = SCNLight()
        spotLight.type = .spot
        spotLight.spotInnerAngle = 45
        spotLight.spotOuterAngle = 45
        let spotNode = SCNNode()
        spotNode.light = spotLight
        spotNode.position = position
        spotNode.eulerAngles = SCNVector3Make(-Float.pi / 2, 0, 0)
        self.spotLight = spotLight
        scnScene.rootNode.addChildNode(spotNode)
    }
}
