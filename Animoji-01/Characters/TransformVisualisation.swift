//
//  TransformVisualisation.swift
//  Animoji-01
//
//  Created by Vikesh JOYPAUL on 25/01/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//
import ARKit
import SceneKit

class TransformVisualization: NSObject, VirtualContentController {
    var name: String?
    var startLeftEye : simd_float3?;
    var endLeftEye : simd_float3?;
    
    var startRightEye : simd_float3?;
    var endRightEye : simd_float3?;
    
    let leftEyeNode: SCNNode?
    let rightEyeNode: SCNNode?
    
    var contentNode: SCNNode?
    
    init(geometry: ARSCNFaceGeometry) {
        leftEyeNode = SCNNode(geometry: SCNCylinder(radius: 0.01, height: 0.03))
        rightEyeNode = SCNNode(geometry: SCNCylinder(radius: 0.01, height: 0.03))
        
        leftEyeNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        rightEyeNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        contentNode = SCNNode()
    }
    
    /// - Tag: ARNodeTracking
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // This class adds AR content only for face anchors.
        guard anchor is ARFaceAnchor else { return nil }
        guard let lec = leftEyeNode, let rec = rightEyeNode else { return nil  }
        contentNode?.addChildNode(lec)
        contentNode?.addChildNode(rec)
        return contentNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard #available(iOS 12.0, *), let faceAnchor = anchor as? ARFaceAnchor else { return }
       
        rightEyeNode?.simdTransform = faceAnchor.rightEyeTransform
        leftEyeNode?.simdTransform = faceAnchor.leftEyeTransform
        
        let rotate:matrix_float4x4 =
            simd_float4x4(SCNMatrix4Mult(SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0), SCNMatrix4MakeTranslation(0, 0, 0.1/2)))
        
        leftEyeNode?.simdTransform =  faceAnchor.leftEyeTransform * rotate;
        rightEyeNode?.simdTransform = faceAnchor.rightEyeTransform * rotate;
    }
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {
        
    }
}
