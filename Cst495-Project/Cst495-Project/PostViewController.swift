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
import Parse


class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var pinLat = Double()
    var pinLong = Double()
    var change = Bool()
    var resizePic: UIImage!
    var compressedImage: UIImage!
    
    let mvc = MapViewController()
    let vc = UIImagePickerController()
    var firstEdit = true
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var charCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPhoto(tapGestureRecognizer:)))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        textBox.delegate = self

        
        imagePicked.isUserInteractionEnabled = true
        imagePicked.addGestureRecognizer(tapGesture)
        self.pinButton.layer.cornerRadius = 25
        self.pinButton.clipsToBounds = true
        self.cancelBtn.layer.cornerRadius = 25
        self.cancelBtn.clipsToBounds = true
        self.imagePicked.layer.cornerRadius = 4
        self.imagePicked.clipsToBounds = true
        self.textBox.layer.cornerRadius = 4
        self.textBox.clipsToBounds = true
        imagePicked.layer.borderWidth = 2
        imagePicked.layer.borderColor = UIColor.gray.cgColor
        textBox.layer.borderWidth = 2
        textBox.layer.borderColor = UIColor.gray.cgColor
        pinButton.layer.borderWidth = 2
        pinButton.layer.borderColor = UIColor.white.cgColor
        cancelBtn.layer.borderWidth = 2
        cancelBtn.layer.borderColor = UIColor.white.cgColor
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
        
        resizePic = originalImage.resizeWithWidth(width: 200)!
        
        let compressData = resizePic.jpegData(compressionQuality: 0.5)
        print("here in pickerfunction")
        print(compressData?.count as Any)
        compressedImage = UIImage(data: compressData!)
        
        self.imagePicked.image = originalImage
        self.imagePicked.contentMode = .scaleAspectFit
        change = true
        dismiss(animated: true, completion: nil)
        
    }

    
    func savePinInfo(pinLat: Double, pinLong: Double, pinImage: UIImage)
    {
        let data = PFObject(className: "pinInfo")
        
        data["pinLong"] = pinLong
        data["pinLat"] = pinLat
        data["comment"] = self.textBox.text
        //data["user"] = PFUser.self
        print("here in pinfunction")
        print(pinImage.jpegData(compressionQuality: 0.5)?.count as Any)
        let imagedata: NSData = pinImage.jpegData(compressionQuality: 0.5)! as! NSData
        let imageFile = PFFile(data: imagedata as Data)
        data["pinImage"] = imageFile
        data["likedCount"] = 1
        data.saveInBackground()
        {
            (successfull,error)-> Void in
            if successfull
            {
                print("data has been sent")
            }
            else
            {
                print("there was an error with saving")
            }
        }
    }
    
    
    @IBAction func pinButton(_ sender: Any) {
        // save pin info here for loading later
        if(change == true)
        {
            pinButton.isEnabled = false
            savePinInfo(pinLat:pinLat, pinLong:pinLong, pinImage: compressedImage)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                self.performSegue(withIdentifier: "pinSegue", sender: self)
            })
            
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "One or more fields haven't been entered", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        //finally go back to main VC
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        charCount.textColor = UIColor.black
        if (firstEdit == true) {
            textBox.text = ""
            firstEdit = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let characterLimit = 70
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // TODO: Update Character Count Label
        charCount.text = String(70 - newText.characters.count)
        
        if newText.characters.count >= 60 {
            charCount.textColor = UIColor.red
        }
        else {
            charCount.textColor = UIColor.darkGray
        }
        
        // The new text should be allowed? True/False
        return newText.characters.count < characterLimit
    }

    
    
    
}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
