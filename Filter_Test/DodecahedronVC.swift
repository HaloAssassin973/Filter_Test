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
        // 2: Add camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        // 3: Place camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
        // 4: Set camera on scene
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        
        // 5: Adding light to scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
        sceneView.scene?.rootNode.addChildNode(lightNode)

        // 6: Creating and adding ambien light to scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        sceneView.scene?.rootNode.addChildNode(ambientLightNode)
        
        let url = Bundle.main.url(forResource: "Dodecahedron", withExtension: "stl")
        let asset = MDLAsset(url: url!)
        asset.loadTextures()
        let object = asset.object(at: 0)
        
        let node = SCNNode(mdlObject: object)
       
        node.position = SCNVector3(x: 0, y: 0, z: 0)
        print(node.boundingBox)
        
        sceneView.scene?.rootNode.addChildNode(node)
        
    }
}
