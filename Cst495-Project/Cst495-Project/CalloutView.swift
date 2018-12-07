//
//  CalloutView.swift
//  Cst495-Project
//
//  Created by Isaac Rodriguez on 12/5/18.
//  Copyright © 2018 rbradley. All rights reserved.
//

import UIKit
import MapViewPlus

class CalloutView: UIView, CalloutViewPlus {
    
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var pinTitle: UILabel!
    @IBOutlet weak var TextBox: UIImageView!
    
    func configureCallout(_ viewModel: CalloutViewModel) {
        let viewModel = viewModel as! CalloutModel
        pinTitle.text = viewModel.title
        pinImageView.image = viewModel.image
        
        self.pinImageView.layer.cornerRadius = 4
        self.pinImageView.clipsToBounds = true
        self.TextBox.layer.cornerRadius = 4
        self.TextBox.clipsToBounds = true
        self.pinTitle.sizeToFit()
        self.pinImageView.layer.borderWidth = 2
        self.pinImageView.layer.borderColor = UIColor.white.cgColor
        self.TextBox.layer.borderWidth = 2
        self.TextBox.layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor(red:255/255, green:223/255, blue:0/255, alpha: 1).cgColor
    }
    
}
