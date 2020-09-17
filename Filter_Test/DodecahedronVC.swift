//
//  DodecahedronVC.swift
//  Filter_Test
//
//  Created by admin on 16.09.2020.
//  Copyright © 2020 Игорь Силаев. All rights reserved.
//
import UIKit
import SceneKit
import ModelIO
import SceneKit.ModelIO

class DodecahedronVC: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        
        let scene = SCNScene(named: "Dodecahedron.scn")
        let node = (scene?.rootNode.childNodes.first)!

        let defaultScene = SCNScene()
        sceneView.scene = defaultScene
        sceneView.scene?.rootNode.addChildNode(node)
        
        centerPivot(for: node)
        
        let action = SCNAction.rotate(by: 360 * CGFloat(Double.pi / 180), around: SCNVector3(x: 0.1, y: 0.1, z: 0), duration: 6)
        let repeatAction = SCNAction.repeatForever(action)
        node.runAction(repeatAction)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 37, z: 0)
        sceneView.scene?.rootNode.addChildNode(cameraNode)

        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 62, z: -12)
        lightNode.rotation = SCNVector4(x: -25, y: 0, z: 0, w: 0)
        sceneView.scene?.rootNode.addChildNode(lightNode)
        

    }
    
    func centerPivot(for node: SCNNode) {
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
