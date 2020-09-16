//
//  ViewController.swift
//  Filter_Test
//
//  Created by Игорь Силаев on 16.09.2020.
//  Copyright © 2020 Игорь Силаев. All rights reserved.
//

import UIKit
import AVKit
import VFCabbage
import CoreMedia

final class ViewController: UIViewController {
    
    // MARK: - Public properties
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    
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
    }
    
    @IBAction func tapChooseButton(_ sender: UIButton) {
        openVideoGallery()
    }
    
    // MARK: - Private methods
    
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

        let composition = AVVideoComposition(asset: asset!, applyingCIFiltersWithHandler: { request in
            
            filter.setValue(CIVector(x: 6500, y: 500), forKey: "inputNeutral")
            filter.setValue(CIVector(x: 1000, y: 630), forKey: "inputTargetNeutral")
            
            // Crop the blurred output to the bounds of the original image
            let output = filter.outputImage!.cropped(to: request.sourceImage.extent)
            
            // Provide the filter output to the composition
            request.finish(with: output, context: nil)
        })
        
        let playerItem = AVPlayerItem(asset: asset!)
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
    }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
    
}
