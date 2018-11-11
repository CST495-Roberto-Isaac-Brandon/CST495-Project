//
//  MapViewController.swift
//  Cst495-Project
//
//  Created by Brandon Shimizu on 10/23/18.
//  Copyright © 2018 rbradley. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

var allPins = [MKPointAnnotation]()


class MapViewController: UIViewController{
    
//static var check = Bool()
//
//    func changeBool(value: Bool) {
//        MapViewController.check = value
//    }
    

    
   
    
    
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var postButton: UIButton!
    
    
    
    
    
    
    let alertController = UIAlertController(title: "Error", message: "User Location Not Enabled", preferredStyle: .alert)
    let locationManger = CLLocationManager()
    let regionInMeters: Double = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewOnUserLocation()
        if(allPins != nil){
            fillArray()
            restorePins()
        }
        
        self.postButton.layer.cornerRadius = 15
        self.postButton.clipsToBounds = true
        
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
            //mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManger.startUpdatingLocation()
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
    
  
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
           //
            setupLocationManager()
            checkLocationAuthorization()
            
        }
        else{
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//            { (action) in
//                // handle cancel response here. Doing nothing will dismiss the view.
//            }
//
//            let OKAction = UIAlertAction(title: "OK", style: .default)
//            { (action) in
//                // handle response here.
//            }

            //
            
        }
        
      
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
    @IBAction func postButton(_ sender: Any) {
        self.performSegue(withIdentifier: "postSegue", sender: self)
    }
    
    
    
//    func setPin(){
//        //mapView.removeAnnotation(newPin)
//        if(locationManger.location == nil){
//            print("there was no location to pin")
//        }
//        else {
//        let newPin = MKPointAnnotation()
//        let location = locationManger.location
//
////        let center = CLLocationCoordinate2D(latitude: (locationManger.location?.coordinate.latitude)!,longitude: (locationManger.location?.coordinate.longitude)!)
//
//        newPin.coordinate = (location?.coordinate)!
//        self.parseSave(pinLocation: newPin)
//        }
//
//        //mapView.addAnnotation(newPin)
//
//    }
    
    func fillArray()
    {
        var query = PFQuery(className: "pinInfo")
        query.findObjectsInBackground
        {(objects, error) -> Void in
            if error == nil
            {
                print("here's the data")
                
                if let latslongs = objects
                {
                    for data in latslongs
                    {
                        var newPin = MKPointAnnotation()
                        newPin.coordinate.latitude = data["pinLat"] as! CLLocationDegrees
                        newPin.coordinate.longitude = data["pinLong"] as! CLLocationDegrees
                        allPins.append(newPin)
                        self.mapView.addAnnotation(newPin)
                    }
                }
            }
        }
    }
    
    //attempting to restore each pin saved in the array.
    func restorePins()
    {
        for pin in allPins
        {
       

           mapView.addAnnotation(pin)
        }

    }
    
    func destroyPins()
    {
//        for pin in allPins
//        {
//            mapView.removeAnnotation(pin)
//        }
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

