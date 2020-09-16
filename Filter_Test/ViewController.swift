//
//  ViewController.swift
//  Filter_Test
//
//  Created by Игорь Силаев on 16.09.2020.
//  Copyright © 2020 Игорь Силаев. All rights reserved.
//

import UIKit
import AVKit

final class ViewController: UIViewController {
    
    // MARK: - Public properties
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Private properties
    private var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tapChooseButton(_ sender: UIButton) {
        openVideoGallery()
    }
    
    // MARK: - Private methods
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
        guard let url = URL else { return }
        let player = AVPlayer(url: url)
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
