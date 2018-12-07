//
//  MapViewController.swift
//  Cst495-Project
//
//  Created by Brandon Shimizu on 10/23/18.
//  Copyright © 2018 rbradley. All rights reserved.
//

import UIKit
import MapKit
import MapViewPlus
import CoreLocation
import Parse

//var allData = [PFObject]()


class MapViewController: UIViewController{

    @IBOutlet weak var mapView: MapViewPlus!
    @IBOutlet weak var postButton: UIButton!
    
    let alertController = UIAlertController(title: "Error", message: "User Location Not Enabled", preferredStyle: .alert)
    let locationManger = CLLocationManager()
    let regionInMeters: Double = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        fillMap()
        
        checkLocationAuthorization()
        
        self.postButton.layer.cornerRadius = 15
        self.postButton.clipsToBounds = true
        self.mapView.layer.cornerRadius = 8
        self.mapView.clipsToBounds = true
        mapView.layer.borderWidth = 2
        mapView.layer.borderColor = UIColor.white.cgColor
        postButton.layer.borderWidth = 2
        postButton.layer.borderColor = UIColor.white.cgColor
    }
    
    
    func centerViewOnUserLocation(){
        if let location = locationManger.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        // When app is open that is only time authorization is allowed
        case .authorizedWhenInUse:
            //Do map stuff
            centerViewOnUserLocation()
            locationManger.startUpdatingLocation()
            mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
            break
        case .denied:
            //Show alert to turn on permissions
            break
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .restricted:
            //Show alert parental restriction on
            break
        //Location can be retrieved in the background
        case .authorizedAlways:
            
            break
        }
    }
    
    func setupLocationManager(){
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @IBAction func postButton(_ sender: Any) {
        self.performSegue(withIdentifier: "postSegue", sender: self)
    }
    
    
    @IBAction func logOutBtn(_ sender: Any) {
        PFUser.logOut()
        self.performSegue(withIdentifier: "logOutSegue", sender: nil) 
    }
    
    
    func fillMap()
    {
        
        let query = PFQuery(className: "pinInfo")
        query.findObjectsInBackground
        {
            (objects, error) -> Void in
            if error == nil
            {
                print("here's the data")
                
                if let latslongs = objects
                {
                    for allData in latslongs
                    {
                        
                        
                        let file = allData["pinImage"] as! PFFile
                        file.getDataInBackground(block: { (data, error) -> Void in
                            if error == nil {
                                if let imagedata = data{
                                    let viewModel = CalloutModel(title: allData["comment"] as! String, image: UIImage(data: imagedata)!)
                                    
                                    let newPin = AnnotationPlus(viewModel: viewModel,
                                                                coordinate: CLLocationCoordinate2DMake(allData["pinLat"] as! CLLocationDegrees, allData["pinLong"] as! CLLocationDegrees))
                                    self.mapView.addAnnotation(newPin)
                                }
                            }
                        })
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "postSegue" {
                    let destVC = segue.destination as? PostViewController
                    //add lat and long here
                    destVC?.pinLat = Double((locationManger.location?.coordinate.latitude)!)
                    destVC?.pinLong = Double((locationManger.location?.coordinate.longitude)!)
                    print("entered the segue zone")
                }
            }
   
}

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MapViewPlusDelegate {
    
    func mapView(_ mapView: MapViewPlus, imageFor annotation: AnnotationPlus) -> UIImage {
        return UIImage(named: "mytourPin3.png")!
    }
    
    func mapView(_ mapView: MapViewPlus, calloutViewFor annotationView: AnnotationViewPlus) -> CalloutViewPlus{
        let calloutView = Bundle.main.loadNibNamed("PinView", owner: self, options: nil)!.first as! CalloutView
        return calloutView
    }
    
    func mapView(_ mapView: MapViewPlus, didAddAnnotations annotations: [AnnotationPlus]) {
        mapView.showAnnotations(annotations, animated: true)
    }
}

