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
    
    func configureCallout(_ viewModel: CalloutViewModel) {
        let viewModel = viewModel as! CalloutModel
        pinTitle.text = viewModel.title
        pinImageView.image = viewModel.image
    }
    

    

}
