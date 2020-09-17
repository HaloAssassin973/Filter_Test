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

final class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Public properties    
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sceneView: DodecahedronSCNView!
        
    // MARK: - Private properties
    private var videoURL: URL? {
        didSet {
            guard let url = videoURL else { return }
            asset = AVAsset(url: url)
        }
    }
    private var asset: AVAsset?
  
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
  
    // MARK: - Actions
    @IBAction func tapChooseButton(_ sender: UIButton) {
        openVideoGallery()
    }
    
    // MARK: - Methods
    private func setupButton() {
        chooseButton.layer.cornerRadius = chooseButton.bounds.height / 2
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
            filter.setValue(CIVector(x: 3000, y: 0), forKey: "inputTargetNeutral")
            
            guard let output = filter.outputImage?.cropped(to: request.sourceImage.extent) else { return }
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
extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        self.dismiss(animated: true, completion: nil)
        createPlayer(URL: videoURL)
        sceneView.isHidden = true
    }
}
