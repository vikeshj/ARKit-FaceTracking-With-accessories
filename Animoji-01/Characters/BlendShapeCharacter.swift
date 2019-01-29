//
//  BlendShapeCharacter.swift
//  Animoji-01
//
//  Created by Vikesh JOYPAUL on 23/01/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

/// - Tag: BlendShapeCharacter
class BlendShapeCharacter: NSObject, VirtualContentController {
    
    var contentNode: SCNNode?
    
     private lazy var neutralNode = contentNode?.childNode(withName: "Neutral", recursively: true)
     private lazy var morphs: [SCNGeometry] = neutralNode?.morpher.flatMap({ return $0.targets }) ?? []
    
    init(geometry: ARSCNFaceGeometry) {
       contentNode = loadedContentForAsset(named: "Character-2/Sample-face", type: "scn")
        super.init()
        let morpher = SCNMorpher()
        morpher.targets = morphs
        morpher.unifiesNormals = true
        neutralNode?.morpher? = morpher
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor, contentNode != nil else { return nil }
        return contentNode
    }
    
    /// - Tag: BlendShapeAnimation
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        let blendShapes = faceAnchor.blendShapes
        guard let eyeBlinkLeft = blendShapes[.eyeBlinkLeft]?.floatValue,
            let eyeBlinkRight = blendShapes[.eyeBlinkRight]?.floatValue,
            let noseSneerLeft = blendShapes[.noseSneerLeft]?.floatValue,
            let noseSneerRight = blendShapes[.noseSneerRight]?.floatValue
            else { return }
        
        let _ = blendShapes.compactMap {
            let g = $0.value as? Float
            let emotion = $0.key.rawValue
//            let hasL = emotion.last(where: { (c) in
//                if c == "L" {
//                    return true
//                }
//                return false
//            })
//            let hasR = emotion.last(where: { (c) in
//                if c == "R" {
//                    return true
//                }
//                return false
//            })
//            
//            emotion = (hasL != nil) ? "\(emotion)eftMesh" : (hasR != nil) ? "\(emotion)ightMesh" : "\(emotion)Mesh"
//            print(emotion)
            neutralNode?.morpher?.setWeight(CGFloat(g ?? 0), forTargetNamed: "\(emotion)Mesh")
        }
        
        neutralNode?.morpher?.setWeight(CGFloat(noseSneerRight), forTargetNamed: "noseSneerRightMesh")
        neutralNode?.morpher?.setWeight(CGFloat(noseSneerLeft), forTargetNamed: "noseSneerLeftMesh")
        neutralNode?.morpher?.setWeight(CGFloat(eyeBlinkRight), forTargetNamed: "eyeBlinkRightMesh")
        neutralNode?.morpher?.setWeight(CGFloat(eyeBlinkLeft), forTargetNamed: "eyeBlinkLeftMesh")
        
        //faceGeometry.update(from: faceAnchor.geometry)
    }
    
    
    
}

enum EmotionType: Int, CustomStringConvertible {
    case eyeBlinkLeft, eyeLookDownLeft, eyeLookLeft, eyeLookOutLeft, eyeLookUpLeft, eyeSquintLeft,  eyeWideLeft
    
    var description: String {
        get {
            return "\(self.rawValue)Mesh"
        }
    }
}
