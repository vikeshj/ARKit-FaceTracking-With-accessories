//
//  Mask.swift
//  Animoji-01
//
//  Created by Vikesh JOYPAUL on 22/01/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import ARKit
import SceneKit

//class Mask: SCNNode, VirtualFaceContent {
//    
//    init(geometry: ARSCNFaceGeometry) {
//        
//        let material = geometry.firstMaterial!
//        
//        material.diffuse.contents = UIColor.lightGray
//        material.lightingModel = .physicallyBased
//        
//        super.init()
//        self.geometry = geometry
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("\(#function) has not been implemented")
//    }
//    
//    // MARK: VirtualFaceContent
//    
//    /// - Tag: SCNFaceGeometryUpdate
//    func update(withFaceAnchor anchor: ARFaceAnchor) {
//        let faceGeometry = geometry as! ARSCNFaceGeometry
//        faceGeometry.update(from: anchor.geometry)
//    }
//}
