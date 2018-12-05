//
//  CalloutViewModel.swift
//  Cst495-Project
//
//  Created by Isaac Rodriguez on 11/27/18.
//  Copyright © 2018 rbradley. All rights reserved.
//

import UIKit
import MapViewPlus

class CalloutModel: CalloutViewModel{
    var title: String
    var image: UIImage
    
    init(title: String, image: UIImage){
        self.title = title
        self.image = image
    }  
}
