//
//  ViewController+ARSCNViewDelegate.swift
//  Animoji-01
//
//  Created by Vikesh JOYPAUL on 22/01/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import ARKit

extension ViewController: ARSCNViewDelegate, ARSessionDelegate {
    // MARK: - AR Render
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        if (contents.count > 0) {
            currentFaceAnchor = faceAnchor
            let _ = contents.compactMap { vc in
                //make sure all contents are added in the parent node
                if node.childNodes.count != contents.count {
                    guard let contentNode = vc.renderer(renderer, nodeFor: faceAnchor) else { return }
                    node.addChildNode(contentNode)
                }
            }
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor == currentFaceAnchor else { return }
        if (contents.count > 0) {
            let _ = contents.compactMap({vc in
                guard let contentNode = vc.contentNode, contentNode.parent == node else { return }
                vc.renderer(renderer, didUpdate: contentNode, for: anchor)
            })
        }
    }
    
    // MARK: - AR Session
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
        currentFaceAnchor = faceAnchor
        let _ = contents.compactMap { vc in
            vc.update(withFaceAnchor: faceAnchor)
        }
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
}
