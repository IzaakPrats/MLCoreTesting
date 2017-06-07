//
//  ViewController.swift
//  MLCoreTesting
//
//  Created by Izaak Prats on 6/6/17.
//  Copyright © 2017 IJVP. All rights reserved.
//

import UIKit
import MobileCoreServices
import Vision
import CoreML

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultsLabel: UILabel!
    
    // MARK: IBActions
    @IBAction func selectPhotoButtonTapped(_ sender: UIButton) {
        // Prompt user for image picker type.
        let actionSheet = UIAlertController(title: "Photo Source", message: "Select a photo source.", preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { alertAction in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }
        
        // Add actions to action sheet
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cameraAction)
        
        // Present action sheet
        self.present(actionSheet, animated: true)
    }
    
    // MARK: Properties
    private var imagePicker: UIImagePickerController!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
    }
    
    // MARK: Setup
    func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    // MARK: Methods
    func predict(image: UIImage) {
        let model = try! VNCoreMLModel(for: Inceptionv3().model)
        let request = VNCoreMLRequest(model: model, completionHandler: myResultsMethod)
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        try! handler.perform([request])
    }
    
    func myResultsMethod(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            resultsLabel.text = "??🙀??"
            return
        }
        
        guard results.count != 0 else {
            resultsLabel.text = "??🙀??"
            return
        }
        
        for classification in results[...10] {
            print(classification.identifier,
                  classification.confidence)
        }
        
        let highestConfidenceResult = results.first!
        
        print(highestConfidenceResult.identifier,
              highestConfidenceResult.confidence)
        
        var identifier = highestConfidenceResult.identifier
        
        if identifier.contains(", ") {
            identifier = String(describing: identifier.split(separator: ",").first!)
        }
        
        resultsLabel.text = identifier
    }
}

// MARK: UINavigationControlerDelegate Extension
extension ViewController: UINavigationControllerDelegate {
    // TODO
    // Don't think I actually need to do anything here.
}

// MARK: UIImagePickerControllerDelegate Extension
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer { imagePicker.dismiss(animated: true) }
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.image = image
        predict(image: image)
    }
}
