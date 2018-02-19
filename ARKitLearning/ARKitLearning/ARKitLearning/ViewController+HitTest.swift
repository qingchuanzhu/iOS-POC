//
//  ViewController+HitTest.swift
//  ARKitLearning
//
//  Created by Qingchuan Zhu on 2/18/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import Foundation
import ARKit
import UIKit

extension ViewController{
    @objc func handleTapFrom(recognizer:UITapGestureRecognizer) {
        // Take the screen space tap coordinates and pass them to the
        // hitTest method on the ARSCNView instance
        let tapPoint = recognizer.location(in: self.sceneView)
        let results = self.sceneView.hitTest(tapPoint, types: .existingPlaneUsingExtent)
        if results.count > 0 {
            let hitResult = results.first
            self.insertGeometry(usingHitResult: hitResult!)
        }
    }
    
    func insertGeometry(usingHitResult hitResult:ARHitTestResult){
        let cubeNode = self.spawnShape()
        // The physicsBody tells SceneKit this geometry should be
        // manipulated by the physics engine
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: cubeNode.geometry!, options: nil))
        cubeNode.physicsBody?.mass = 2.0;
        cubeNode.physicsBody?.categoryBitMask = CollisionCategory.CollisionCategoryCube.rawValue
        
        // We insert the geometry slightly above the point the user tapped
        // so that it drops onto the plane using the physics engine
        let inserionYOffset:Float = 0.5
        cubeNode.position = SCNVector3Make(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y + inserionYOffset,
            hitResult.worldTransform.columns.3.z)
        
        self.scnScene.rootNode.addChildNode(cubeNode)
    }
}
