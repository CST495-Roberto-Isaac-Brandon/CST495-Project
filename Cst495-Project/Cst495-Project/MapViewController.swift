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

class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var postButton: UIButton!
    var check = Bool()
    
    
    
    let alertController = UIAlertController(title: "Error", message: "User Location Not Enabled", preferredStyle: .alert)
    let locationManger = CLLocationManager()
    let regionInMeters: Double = 1000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(check)
        if(check == true){
            setPin()
            print("check is now true")
            check = false
        }
//        let montRegion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(36.65442, -121.8018),span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//        mapView.setRegion(montRegion, animated: false)
        checkLocationAuthorization()
    }
    
    
    func centerViewOnUserLocation(){
        if let location = locationManger.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
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
    
    
    
    func setPin(){
        //mapView.removeAnnotation(newPin)
        let location = locationManger.location
        let center = CLLocationCoordinate2D(latitude: (locationManger.location?.coordinate.latitude)!,longitude: (locationManger.location?.coordinate.longitude)!)
        newPin.coordinate = (location?.coordinate)!
        mapView.addAnnotation(newPin)
    }
    
}

let newPin = MKPointAnnotation()

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

