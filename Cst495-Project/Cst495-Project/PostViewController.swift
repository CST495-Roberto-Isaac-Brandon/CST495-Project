//
//  PostViewController.swift
//  Cst495-Project
//
//  Created by Brandon Shimizu on 10/26/18.
//  Copyright © 2018 rbradley. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let mvc = MapViewController()
    let vc = UIImagePickerController()
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var pinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPhoto(tapGestureRecognizer:)))
        
        imagePicked.isUserInteractionEnabled = true
        imagePicked.addGestureRecognizer(tapGesture)
        self.pinButton.layer.cornerRadius = 25
        self.pinButton.clipsToBounds = true
    }
    
    @objc func tappedPhoto(tapGestureRecognizer: UITapGestureRecognizer){
        
        imagePickerHelper()
        
    }
    
    func imagePickerHelper() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.imagePicked.image = originalImage
        self.imagePicked.contentMode = .scaleAspectFit
        
        dismiss(animated: true, completion: nil)
        
        // Do something with the images (based on your use case)Cannot subscript a value of type '[String : Any]' with an index of type 'UIImagePickerController.InfoKe
        
        // Dismiss UIImagePickerController to go back to your original view controller
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pinSegue" {
            let dvc = segue.destination as? MapViewController
            dvc?.check = true
            print("entered the segue zone")
        }
    }
    
    
    
    
    @IBAction func pinButton(_ sender: Any) {
//        MapViewController().setPin()
        self.performSegue(withIdentifier: "pinSegue", sender: self)
    }
    
    
    
    
    
    
}
