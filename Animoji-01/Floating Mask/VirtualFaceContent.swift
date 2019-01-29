//
//  VirtualFaceContent.swift
//  Animoji-01
//
//  Created by Vikesh JOYPAUL on 22/01/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import ARKit
import SceneKit

protocol VirtualContentController: ARSCNViewDelegate {
    /// The root node for the virtual content.
    var contentNode: SCNNode? { get set }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor)
}

// MARK: Loading Content

func loadedContentForAsset(named resourceName: String, type: String) -> SCNNode {
    if let url = Bundle.main.url(forResource: resourceName, withExtension: type, subdirectory: "Models.scnassets") {
        if let node = SCNReferenceNode(url: url) {
            node.load()
            return node
        }
    }
    return SCNNode()
}

func loadedContentFromSceneSource(named resourceName: String) -> SCNSceneSource {
    if let url = Bundle.main.url(forResource: resourceName, withExtension: "scn", subdirectory: "Models.scnassets") {
        if let source = SCNSceneSource(url: url, options: nil) {
            return source
        }
    }
    return SCNSceneSource()
}

