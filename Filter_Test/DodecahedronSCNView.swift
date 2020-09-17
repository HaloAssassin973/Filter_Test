//
//  DodecahedronSCNView.swift
//  Filter_Test
//
//  Created by Игорь Силаев on 16.09.2020.
//  Copyright © 2020 Игорь Силаев. All rights reserved.
//

import UIKit
import SceneKit

class DodecahedronSCNView: SCNView {
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        setupAndCreateFigure()
    }
    
    // MARK: - Methods
    private func setupAndCreateFigure() {
        let dodecahedronScene = SCNScene(named: "Dodecahedron.scn")
        guard let dodecahedronNode = (dodecahedronScene?.rootNode.childNodes.first) else { return }

        let defaultScene = SCNScene()
        scene = defaultScene
        scene?.rootNode.addChildNode(dodecahedronNode)
        
        centerPivot(for: dodecahedronNode)
        
        let action = SCNAction.rotate(by: 360 * CGFloat(Double.pi / 180), around: SCNVector3(x: 0.1, y: 0.1, z: 0), duration: 6)
        let repeatAction = SCNAction.repeatForever(action)
        dodecahedronNode.runAction(repeatAction)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 37, z: -10)
        scene?.rootNode.addChildNode(cameraNode)

        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 62, z: -12)
        lightNode.rotation = SCNVector4(x: -25, y: 0, z: 0, w: 0)
        scene?.rootNode.addChildNode(lightNode)
    }
    
    private func centerPivot(for node: SCNNode) {
        var min = SCNVector3Zero
        var max = SCNVector3Zero
        node.__getBoundingBoxMin(&min, max: &max)
        node.pivot = SCNMatrix4MakeTranslation(
            min.x + (max.x - min.x)/2,
            min.y + (max.y - min.y)/2,
            min.z + (max.z - min.z)/2
        )
    }

}
