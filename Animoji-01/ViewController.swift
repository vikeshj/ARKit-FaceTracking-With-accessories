//
//  ViewController.swift
//  Animoji-01
//
//  Created by Vikesh JOYPAUL on 22/01/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//
import Foundation
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    var camera: ARCamera? {
        guard let camera = sceneView.session.currentFrame?.camera else { return nil }
        return camera
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
        sceneView.rendersContinuously = true
        sceneView.allowsCameraControl = false
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = false
        //sceneView.debugOptions = ARSCNDebugOptions.showBoundingBoxes
        session.delegate = self
        
        guard let device = MTLCreateSystemDefaultDevice(), let faceGeometry =  ARSCNFaceGeometry(device: device, fillMesh: false) else { return }
        
        //add contents
        contents.append(BlendShapeCharacter(geometry: faceGeometry))
        //contents.append(TransformVisualization(geometry: faceGeometry))
        //contents.append(FaceOcclusionOverlay(geometry: faceGeometry))
        
        
        let node = sceneView.scene.rootNode
        if (contents.count > 0) {
            let _ = contents.compactMap { vc in
                //make sure all contents are added in the parent node
                guard let contentNode = vc.contentNode else { return }
                node.addChildNode(contentNode)
            }
        }
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
    
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        guard touch.tapCount == 1 else { return }
//        guard let camera = sceneView.session.currentFrame?.camera else { return }
//        let transform = getCameraTransform(for: camera)
//        let position = SCNVector3(x: transform.translation.x,
//                                        y: transform.translation.y,
//                                        z: transform.translation.z)
//    }
    
    func getCameraTransform(for camera: ARCamera) -> MDLTransform {
        return MDLTransform(matrix: camera.transform)
    }
    
    func faceFrame(from boundingBox: CGRect) -> CGRect {
        
        //translate camera frame to frame inside the ARSKView
        let origin = CGPoint(x: boundingBox.minX * sceneView.bounds.width, y: (1 - boundingBox.maxY) * sceneView.bounds.height)
        let size = CGSize(width: boundingBox.width * sceneView.bounds.width, height: boundingBox.height * sceneView.bounds.height)
        
        return CGRect(origin: origin, size: size)
    }
}




