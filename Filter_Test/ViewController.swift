//
//  ViewController.swift
//  Filter_Test
//
//  Created by Игорь Силаев on 16.09.2020.
//  Copyright © 2020 Игорь Силаев. All rights reserved.
//

import UIKit
import AVKit
import CoreMedia
import SceneKit

final class ViewController: UIViewController {
    
    // MARK: - Public properties
    
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sceneView: SCNView!
    
    
    // MARK: - Private properties
    
    private var videoURL: URL? {
        didSet {
            guard let url = videoURL else { return }
            asset = AVAsset(url: url)
        }
    }
    private var asset: AVAsset?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupAndCreateFigure()
    }
    
    @IBAction func tapChooseButton(_ sender: UIButton) {
        openVideoGallery()
    }
    
    // MARK: - Private methods
    
    private func setupButton() {
        chooseButton.layer.cornerRadius = chooseButton.bounds.height / 2
    }
    
    private func setupAndCreateFigure() {
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
    
    private func openVideoGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        guard let mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) else { return }
        picker.mediaTypes = mediaTypes
        picker.mediaTypes = ["public.movie"]
        
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    private func createPlayer(URL: URL?) {
        guard let filter = CIFilter(name: "CITemperatureAndTint") else { return }
        guard let asset = asset else { return }

        let composition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in
            
            let source = request.sourceImage.clampedToExtent()
            filter.setValue(source, forKey: kCIInputImageKey)
            
            filter.setValue(CIVector(x: 6500, y: 0), forKey: "inputNeutral")
            filter.setValue(CIVector(x: 2500, y: 0), forKey: "inputTargetNeutral")
            
            let output = filter.outputImage!.cropped(to: request.sourceImage.extent)
            request.finish(with: output, context: nil)
        })
        
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.videoComposition = composition
        
        let player = AVPlayer(playerItem: playerItem)
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.view.frame = containerView.frame
        self.addChild(playerController)
        self.view.addSubview(playerController.view)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        self.dismiss(animated: true, completion: nil)
        createPlayer(URL: videoURL)
        sceneView.removeFromSuperview()
    }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
    
}
