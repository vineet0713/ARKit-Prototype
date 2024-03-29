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
    
    var planes = [UUID : VirtualPlane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Improves the lighting of the sceneView
        sceneView.autoenablesDefaultLighting = true
        
        // Sets debug options on the sceneView
        let debugValue: UInt = ARSCNDebugOptions.showWorldOrigin.rawValue | ARSCNDebugOptions.showFeaturePoints.rawValue
        sceneView.debugOptions = SCNDebugOptions(rawValue: debugValue)
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(addCouchToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc func addCouchToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first else {
            print("hitTestResult was not able to be initialized!")
            return
        }
        let translation = hitTestResult.worldTransform.columns.3
        let x = translation.x
        let y = translation.y
        let z = translation.z
        
        guard let couchScene = SCNScene(named: "art.scnassets/couch.dae") else {
            print("couchScene was not able to be initialized!")
            return
        }
        
        guard let couchNode = couchScene.rootNode.childNode(withName: "couchModel", recursively: true) else {
            print("couchNode was not able to be initialized!")
            return
        }
        couchNode.position = SCNVector3(x,y,z)
        couchNode.scale = SCNVector3(0.75, 0.75, 0.75)
        sceneView.scene.rootNode.addChildNode(couchNode)
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let arPlaneAnchor = anchor as? ARPlaneAnchor else {
            print("arPlaneAnchor was not able to be initialized!")
            return
        }
        let plane = VirtualPlane(anchor: arPlaneAnchor)
        self.planes[arPlaneAnchor.identifier] = plane
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let arPlaneAnchor = anchor as? ARPlaneAnchor else {
            print("arPlaneAnchor was not able to be initialized!")
            return
        }
        guard let plane = planes[arPlaneAnchor.identifier] else {
            print("plane was not able to be initialized!")
            return
        }
        plane.updateWithNewAnchor(arPlaneAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let arPlaneAnchor = anchor as? ARPlaneAnchor else {
            print("arPlaneAnchor was not able to be initialized!")
            return
        }
        guard let index = planes.index(forKey: arPlaneAnchor.identifier) else {
            print("index was not able to be initialized!")
            return
        }
        planes.remove(at: index)
        sceneView.scene.rootNode.removeAllActions()
    }
    
}
