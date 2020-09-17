//
//  DodecahedronSCNView.swift
//  Filter_Test
//
//  Created by Игорь Силаев on 16.09.2020.
//  Copyright © 2020 Игорь Силаев. All rights reserved.
//

import UIKit
import SceneKit

class IcosahedronSCNView: SCNView {
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        setupAndCreateFigure()
    }
    
    // MARK: - Methods
    private func setupAndCreateFigure() {
        let icosahedronScene = SCNScene(named: "Icosahedron.scn")
        guard let icosahedronNode = (icosahedronScene?.rootNode.childNodes.first) else { return }

        let defaultScene = SCNScene()
        scene = defaultScene
        scene?.rootNode.addChildNode(icosahedronNode)
        
        let action = SCNAction.rotate(by: 360 * CGFloat(Double.pi / 180), around: SCNVector3(x: 0.1, y: 0.1, z: 0), duration: 6)
        let repeatAction = SCNAction.repeatForever(action)
        icosahedronNode.runAction(repeatAction)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 2)
        scene?.rootNode.addChildNode(cameraNode)

        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 8, z: 10)
        lightNode.rotation = SCNVector4(x: -25, y: 0, z: 0, w: 0)
        scene?.rootNode.addChildNode(lightNode)
    }

}
