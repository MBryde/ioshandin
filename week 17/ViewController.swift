//
//  ViewController.swift
//  17_Sensors
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit
import MapKit
import CoreMotion

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var regionInMeters: Double = 900
    var motionManager = CMMotionManager()
    var queue = OperationQueue()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        // Do any additional setup after loading the view.
        
        checkLocationService()
        
        if motionManager.isDeviceMotionActive{
            startMovementDetection()
        }else{
            print("Device motion isn't available")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        motionManager.stopDeviceMotionUpdates()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            centerViewOnUserLocation()
        }
    }
    
    func startMovementDetection(){
        motionManager.deviceMotionUpdateInterval = 0.1
        
        motionManager.startDeviceMotionUpdates(to: queue) { (motion, error) in
            guard let motion = motion else { return }
            
            print("started")
            print(motion.attitude.pitch)
            
            // To make sure that the app won't zoom in or out to easy, we need to set a threshold
            if motion.attitude.pitch > 1{
                self.zoom(direction: "out", motion: motion.attitude.pitch)
                
            } else if motion.attitude.pitch < 0{
                self.zoom(direction: "in", motion: motion.attitude.pitch)
            }
        }
    }
    
    // MARK: - Map View Setup


    // centers the view on the user location
    func centerViewOnUserLocation(){
        // unwraps the optional (user locations coordinates)
        if let location = locationManager.location?.coordinate {
            
            // sets the region
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            
            // sets the region on the map with our newly created region
            map.setRegion(region, animated: true)
        }
    }
    
    
    func zoom(direction: String, motion: Double) {
        // To get an equal amount of zoom whether we are zooming in or out, we need to substract one from the motion before assigning it to the zoomValue if we are zooming out
        var zoomValue = direction.elementsEqual("out") ? motion-1 : motion
        
        switch regionInMeters {
        case 0...250:
            if direction.elementsEqual("in"){
                print("Stopped zooming in")
                zoomValue = 0
            }else{
                zoomValue *= 250
            }
        case 251...500:
            print("0")
            zoomValue *= 250
        case 501...1000:
            zoomValue = motion * 500
            print("1")
        case 1001...2000:
            zoomValue = motion * 1000
            print("2")
        case 2001...4000:
            zoomValue = motion * 2000
            print("3")
        case 4001...8000:
            zoomValue = motion * 4000
            print("4")
        default:
            if direction.elementsEqual("in"){
                zoomValue = motion * 8000
            }else{
                print("Stopped zooming out")
                zoomValue = 0
            }
        }
        
        // If the motion is less than zero, then we are tilting the device forwards, and we need to zoom in on the map
        if zoomValue.isLess(than: 0){
            // the region is set to the positive value of the motion
            regionInMeters -= zoomValue * -1
            print("New Region(-):\(regionInMeters)")
        // if the motion is above zero, then we are tilting the device backwards, and then we need to zoom out on the map
        }else{
            // because of the
            regionInMeters += zoomValue
            print("New Region(+):\(regionInMeters)")
        }
        /*
        // the region is set to the positive value of the motion
        regionInMeters -= zoomValue * -1
        print("New Region(-):\(regionInMeters)")*/
        
        let region = MKCoordinateRegion(center: map.centerCoordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        DispatchQueue.main.async {
            // if the zoom value is smaller than the region in meters then we can set the region
            self.map.setRegion(region, animated: true)
        }
    }
    
    
    // MARK: - User Location Setup With Authorization
    
    // function that checks if the location services of the device isn't turned off
    func checkLocationService(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
        }else{
            // create an alert that tells the user to turn on location services
            print("what")
        }
    }
    
    // function that sets up the location manager which handles the user location
    func setUpLocationManager(){
        locationManager.delegate = self // sets the delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // sets the desired accuracy to the best possible accuracy
    }
    
    // Checks what kind of authorization is given
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
            
        // When the app is used, we are authorized to access the user location
        case .authorizedWhenInUse:
            print("when in use")
            startUpdatingUserLocationWhenAuthorized()
            break
            
        // If we are denied access by the user
        case .denied:
            print("denied")
            // show an alert to make the user know that it's device hasn't given permission
            break
            
        // first time the app is opened, or if user chooese only to give access one time
        case .notDetermined:
            print("not determined")
            // we net to setup the p-list to be able to ask for authorization
            locationManager.requestWhenInUseAuthorization() // requests the type of authorization that we want
            break
            
        // if the user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place
        case .restricted:
            print("restricted")
            // show alert
            break
            
        // if it's always it should start updating user location
        case .authorizedAlways:
            print("always")
            startUpdatingUserLocationWhenAuthorized()
            break
            
        // if a defailt shpuld come in future updates we are covered by @unkown
        @unknown default:
            print("my default")
            break
        }
    }
    
    func startUpdatingUserLocationWhenAuthorized(){
        map.showsUserLocation = true // shows the blue dot on the map
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation() // Calls the didUpdateLocation method in the extension
        //if the user moves, the locationmanager will update the location
    }

}


// MARK: - Location manager setup
extension ViewController: CLLocationManagerDelegate {
    // every time the user moves, this function is fired off
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        map.setRegion(region, animated: true)
    }
    
    // if the authorization changes, then we need to call our checkAuthorization function from above
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
