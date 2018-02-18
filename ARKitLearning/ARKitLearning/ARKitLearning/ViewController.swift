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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // This property is not affect AR experience, the lighting is not following real world lights
//        sceneView.autoenablesDefaultLighting = true
        
        // This property does not do anything
        sceneView.automaticallyUpdatesLighting = false
        
        // Create a new scene
        scnScene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scnScene
        spawnShape()
//        insertSpotLight(position: SCNVector3Make(0, 0.4, -0.5))
        let env = UIImage(named: "environmentMap.png")
        
        // Set Environment Map
        sceneView.scene.lightingEnvironment.contents = env
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
    
    // MARK: - Node handling
    func spawnShape() {
        
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
        scnScene.rootNode.addChildNode(geometryNode)
    }
    
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
