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
    var planeGeometry : SCNBox?
    var gridMaterial: SCNMaterial!
    var transparentMaterial: SCNMaterial!
    
    init(withAnchor anchor:ARPlaneAnchor ) {
        super.init()
        
        // Using a SCNBox and not SCNPlane to make it easy for the geometry we add to the
        // scene to interact with the plane.
        
        // For the physics engine to work properly give the plane some height so we get interactions
        // between the plane and the gometry we add to the scene
        
        let planeHeight:Float = 0.001
        
        self.planeGeometry = SCNBox(width: CGFloat(anchor.extent.x), height: CGFloat(planeHeight) , length: CGFloat(anchor.extent.z), chamferRadius: 0)
        let planeNode = SCNNode(geometry: self.planeGeometry)
        
        planeNode.opacity = 0.5
        planeNode.position = SCNVector3Make(anchor.center.x, planeHeight / 2.0, anchor.center.z)
//        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0);
        
        planeNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: self.planeGeometry!, options: nil))
        
        // Add Grid to the 'plane'
        // Instead of just visualizing the grid as a gray plane, we will render
        // it in some Tron style colours.
        gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "tron_grid")
        
        // Since we are using a cube, we only want to render the tron grid
        // on the top face, make the other sides transparent
        transparentMaterial = SCNMaterial()
        transparentMaterial.diffuse.contents = UIColor.init(white: 1.0, alpha: 0.0)
        
        self.planeGeometry?.materials = [transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, gridMaterial, transparentMaterial]
        
        self.setTextureScale()
        
        self.addChildNode(planeNode)
    }
    
    func setTextureScale() {
        let width:Float = Float((self.planeGeometry?.width)!);
        let height:Float = Float((self.planeGeometry?.length)!);
    
    // As the width/height of the plane updates, we want our tron grid material to
    // cover the entire plane, repeating the texture over and over. Also if the
    // grid is less than 1 unit, we don't want to squash the texture to fit, so
    // scaling updates the texture co-ordinates to crop the texture in that case
        let material = self.planeGeometry?.materials[4];
        
        let scale = SCNMatrix4MakeScale(width, height, 1);
        material?.diffuse.contentsTransform = scale
        material?.diffuse.wrapS = .repeat;
        material?.diffuse.wrapT = .repeat;
    }
    
    func updatePlane(withAnchor anchor:ARPlaneAnchor) {
        self.planeGeometry?.width = CGFloat(anchor.extent.x);
        self.planeGeometry?.length = CGFloat(anchor.extent.z);
        
        // When the plane is first created it's center is 0,0,0 and
        // the nodes transform contains the translation parameters.
        // As the plane is updated the planes translation remains the
        // same but it's center is updated so we need to update the 3D
        // geometry position
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        let planeNode = self.childNodes.first
        planeNode?.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: self.planeGeometry!, options: nil))
        self.setTextureScale()
    }
    
    func hide() {
        self.planeGeometry?.materials = [transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial]
    }
    
    func show() {
        self.planeGeometry?.materials = [transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, gridMaterial, transparentMaterial]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
