//
//  FaceOcclusionOverlay.swift
//  Animoji-01
//
//  Created by Vikesh JOYPAUL on 24/01/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import ARKit
import SceneKit

class FaceOcclusionOverlay: NSObject, VirtualContentController {
    var name: String?
    var contentNode: SCNNode?
    var occlusionNode: SCNNode!
    var hat: SCNNode!
    
    init(geometry: ARSCNFaceGeometry) {
        geometry.firstMaterial!.colorBufferWriteMask = []
        occlusionNode = SCNNode(geometry: geometry)
        //occlusionNode.renderingOrder = -1
    }
    
    /// - Tag: OcclusionMaterial
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        // Add 3D asset positioned to appear as "glasses".
        hat = loadedContentForAsset(named: "Character-2/hat", type: "scn")
        contentNode = SCNNode()
        contentNode!.addChildNode(occlusionNode)
        contentNode!.addChildNode(hat)
       
        return contentNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = occlusionNode.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
        hat.position.y = faceGeometry.boundingSphere.radius
    }
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {
        
    }
}
