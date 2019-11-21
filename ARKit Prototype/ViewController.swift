//
//  ViewController.swift
//  ARKit Prototype
//
//  Created by Vineet Joshi on 11/21/19.
//  Copyright © 2019 Vineet Joshi. All rights reserved.
//

//  3D Model retrieved from: https://poly.google.com/view/7Q_Ab2HLll1

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Improves the lighting of the sceneView
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        let scene = SCNScene()
        
        guard let couchScene = SCNScene(named: "art.scnassets/couch.dae") else {
            print("couchScene was not able to be initialized!")
            return
        }
        
        guard let couchNode = couchScene.rootNode.childNode(withName: "couchModel", recursively: true) else {
            print("couchNode was not able to be initialized!")
            return
        }
        // Sets the position of the couchNode (x,y,z), where z=-1 means 1 meter AWAY from us
        couchNode.position = SCNVector3(0, 0, -1)
        
        scene.rootNode.addChildNode(couchNode)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
