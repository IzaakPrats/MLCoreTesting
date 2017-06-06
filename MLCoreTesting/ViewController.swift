//
//  ViewController.swift
//  MLCoreTesting
//
//  Created by Izaak Prats on 6/6/17.
//  Copyright © 2017 IJVP. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBAction func selectPhotoButtonTapped(_ sender: UIButton) {
        // Prompt user
        self.present(imagePicker, animated: true)
    }
    
    private var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupImagePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = [kUTTypeJPEG as String]
        imagePicker.sourceType = .photoLibrary
    }
}

extension ViewController: UINavigationControllerDelegate {
    // TODO
    // Don't think I actually need to do anything here.
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer { imagePicker.dismiss(animated: true) }
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
    }
}
