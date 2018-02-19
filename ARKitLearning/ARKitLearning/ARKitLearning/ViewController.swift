//
//  ViewController.swift
//  ARKitLearning
//
//  Created by Qingchuan Zhu on 2/15/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var scnScene: SCNScene!
    var spotLight: SCNLight!
    var planes: [UUID : Plane]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.planes = [UUID : Plane]()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // This property does not do anything
        sceneView.automaticallyUpdatesLighting = false
        
        // Create a new scene
        scnScene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scnScene
        let env = UIImage(named: "environmentMap.png")
        
        // Set Environment Map
        sceneView.scene.lightingEnvironment.contents = env
        
        // User interactive handling
        self.setupGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravity
        configuration.isLightEstimationEnabled = true
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func setupGestureRecognizer() {
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        singleTapRecognizer.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(singleTapRecognizer)
    }
    
    // MARK: - Node handling
    func spawnShape()->SCNNode {
        
        let mat = SCNMaterial()
        mat.lightingModel = .physicallyBased
        mat.diffuse.contents = UIImage(named: "wornpaintedwoodsiding-albedo")
        mat.roughness.contents = UIImage(named:"wornpaintedwoodsiding-roughness")
        mat.metalness.contents = UIImage(named:"wornpaintedwoodsiding-metalness")
        mat.normal.contents = UIImage(named:"wornpaintedwoodsiding-normal-ue")
        
        var geometry:SCNGeometry
        switch ShapeType.random() {
        default:
            geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1,
                              chamferRadius: 0.0)
        }
        geometry.materials = [mat]
        let geometryNode = SCNNode(geometry: geometry)
        geometryNode.position = SCNVector3Make(0, 0, -0.5)
        return geometryNode
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let lightEst = sceneView.session.currentFrame?.lightEstimate else {
            return
        }
        guard let spotLight = self.spotLight else {
            return
        }
        spotLight.intensity = lightEst.ambientIntensity
        // Set intensity of the lighting environment
        let intensity = lightEst.ambientIntensity / 1000.0
        sceneView.scene.lightingEnvironment.intensity = intensity
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Create the 3D plane geometry with the dimensions reported
        // by ARKit in the ARPlaneAnchor instance
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        let plane = Plane(withAnchor: planeAnchor)
        node.addChildNode(plane)
        self.planes?.updateValue(plane, forKey: anchor.identifier)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let plane = self.planes?[anchor.identifier], let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        plane.updatePlane(withAnchor: planeAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        self.planes?.removeValue(forKey: anchor.identifier)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
