//
//  Plane.swift
//  ARKitLearning
//
//  Created by Qingchuan Zhu on 2/18/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import SceneKit
import ARKit

class Plane: SCNNode {
    var planeGeometry : SCNPlane?
    
    init(withAnchor anchor:ARPlaneAnchor ) {
        super.init()
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        self.planeGeometry?.widthSegmentCount = 50
        self.planeGeometry?.heightSegmentCount = 50
        let planeNode = SCNNode(geometry: self.planeGeometry)
        
        planeNode.opacity = 0.5
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0);
        
        planeNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: self.planeGeometry!, options: nil))
        self.addChildNode(planeNode)
    }
    
    func updatePlane(withAnchor anchor:ARPlaneAnchor) {
        self.planeGeometry?.width = CGFloat(anchor.extent.x);
        self.planeGeometry?.height = CGFloat(anchor.extent.z);
        // When the plane is first created it's center is 0,0,0 and
        // the nodes transform contains the translation parameters.
        // As the plane is updated the planes translation remains the
        // same but it's center is updated so we need to update the 3D
        // geometry position
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        let planeNode = self.childNodes.first
        planeNode?.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: self.planeGeometry!, options: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
