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
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    
    var Liked: Bool?
    var disLiked: Bool?
    var alreadyLiked: Bool?
    var alreadyDisLiked: Bool?
    var counter: Int = 1
    
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
    
    @IBAction func onLikeTap(_ sender: Any)
    {
        print(counter)
        
        
        
        if(alreadyLiked == true) {
            likeButton.setImage(UIImage(named:"pinPlusWhite.png"), for: .normal)
            counter-=1
            likeCount.text = String(counter)
            
            alreadyLiked = false
        }
        else{
            Liked = true
            disLiked = false

            if (Liked==true)
            {
                likeButton.setImage(UIImage(named:"pinPlusLiked35.png"), for: .normal)
                counter+=1
                likeCount.text = String(counter)
                alreadyLiked = true
                alreadyDisLiked = false
                dislikeButton.setImage(UIImage(named:"pinMinusWhite.png"), for: .normal)
            }
            else{
                likeButton.setImage(UIImage(named:"pinPlusWhite.png"), for: .normal)
                counter-=1
                likeCount.text = String(counter)
                
            }
        }
    }
    @IBAction func onDislikeTap(_ sender: Any)
        {
        print("dislike Tapped")
           
            if(alreadyDisLiked == true)
            {
                dislikeButton.setImage(UIImage(named:"pinMinusWhite.png"), for: .normal)
                counter += 1
                likeCount.text = String(counter)
                alreadyDisLiked = false
            }
            else{
                disLiked = true
                Liked = false
                if (disLiked == true)
                {
                    dislikeButton.setImage(UIImage(named:"pinMinusDisliked.png"), for: .normal)
                    counter -= 1
                    likeCount.text = String(counter)
                    alreadyDisLiked = true
                    alreadyLiked = false
                    likeButton.setImage(UIImage(named:"pinPlusWhite.png"), for: .normal)
                    
                }
                else{
                    likeButton.setImage(UIImage(named:"pinMinusWhite.png"), for: .normal)
                    counter += 1
                    likeCount.text = String(counter)
                }
            }
    }
    
}
