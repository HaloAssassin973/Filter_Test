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
        let action = SCNAction.rotate(by: 360 * CGFloat(Double.pi / 180), around: SCNVector3(x:0, y:1, z:0), duration: 3)
        let repeatAction = SCNAction.repeatForever(action)
        node.runAction(repeatAction)
        node.position = SCNVector3(x: 0, y: 0, z: 0)
        let defaultScene = SCNScene()
        sceneView.scene = defaultScene
        sceneView.scene?.rootNode.addChildNode(node)
        
        
        //        sceneView.scene = scene
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 37, z: 0)
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        
        // 5: Adding light to scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
        sceneView.scene?.rootNode.addChildNode(lightNode)
        
        //        // 6: Creating and adding ambien light to scene
        //        let ambientLightNode = SCNNode()
        //        ambientLightNode.light = SCNLight()
        //        ambientLightNode.light?.type = .ambient
        //        ambientLightNode.light?.color = UIColor.darkGray
        //        sceneView.scene?.rootNode.addChildNode(ambientLightNode)
        
    }
}
