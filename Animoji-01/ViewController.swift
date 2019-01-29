//
//  ViewController.swift
//  Animoji-01
//
//  Created by Vikesh JOYPAUL on 22/01/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    var currentFaceAnchor: ARFaceAnchor?
    var contents: [VirtualContentController] = [] // needs to replace with a dictionary later on
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.backgroundColor = .white
        sceneView.automaticallyUpdatesLighting = true
        sceneView.delegate = self
        //sceneView.scene.background.contents = UIColor.white
        sceneView.antialiasingMode = .multisampling2X
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        //sceneView.debugOptions = ARSCNDebugOptions.showBoundingBoxes
        session.delegate = self
        
        guard let device = MTLCreateSystemDefaultDevice(), let faceGeometry =  ARSCNFaceGeometry(device: device, fillMesh: false) else { return }
        
        //add contents
        contents.append(BlendShapeCharacter(geometry: faceGeometry))
        //contents.append(TransformVisualization(geometry: faceGeometry))
        contents.append(FaceOcclusionOverlay(geometry: faceGeometry))
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        configuration.worldAlignment = .gravity
        configuration.isLightEstimationEnabled = true
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
