//
// Map3ViewController.swift
// PopUp
//
//  Created by Casey Corvino on 10/24/16.
//  Copyright © 2016 PopUp. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation

var activeCoordinate = -1;

var popUps = [PopUp]()



class MapViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager() //instantiating user location
    
    var backendless = Backendless.sharedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //user location setup
         self.map.delegate = self
        
       
        
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        sleep(1)
        
        locationManager.stopUpdatingLocation()
        
        //end of setup
        
        initPopUpArray()
        updateLocation()
        updatePopUps()
    }
    
    
    
    
    @IBAction func updateButton(sender: AnyObject) {
        initPopUpArray()
        updateLocation()
        updatePopUps()
        
        activeCoordinate = -1;
    }
    
    
    
    
    func initPopUpArray(){
        //give popUp values from backend
        print("\n============ Fetching first page using the ASYNC API ============")
        let startTime = NSDate()
        let query = BackendlessDataQuery()
        backendless.persistenceService.of(PopUp.ofClass()).find(
            query,
            response: { ( p : BackendlessCollection!) -> () in
                let currentPage = p.getCurrentPage()
                print("Loaded \(currentPage.count) PopUp objects")
                print("Total PopUps in the Backendless starage - \(p.totalObjects)")
                
                popUps = [PopUp]()
                for p in currentPage as! [PopUp] {
                    print("PopUp name = \(p.popUpTitle)")
                    popUps.append(p)
                }
                print("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    
    
    
    func updateLocation(){

        locationManager.startUpdatingLocation()//this runs locationManager()
        
        sleep(1)
        
        locationManager.stopUpdatingLocation()
        
        //print(activeCoordinate)
    
    }
    
    
    
    func deleteAllAnnotations(){
        
        let allAnnotations = self.map.annotations
        
        self.map.removeAnnotations(allAnnotations)
        
    }
    
    
    
    func updatePopUps(){
        //get the first 20 PopUps by distance
        for i in 0 ..< popUps.count{
            let p = popUps[i]
            //create annotations
            createAnnotation(p)
        }
    }
    
    
    
    func isInNext24Hrs( p: PopUp) -> Bool{
        return true;
    }

    
    
   
    
    
    func createAnnotation(pop: PopUp){
        
        let title = pop.popUpTitle
        
        let time = pop.getPopUpTimeStr();
        
        let endTime = pop.getPopUpEndTimeStr()
        
        let geocoder: CLGeocoder = CLGeocoder() // optimize this
        geocoder.geocodeAddressString(pop.popUpAddress, completionHandler: { (placemarks, error) in
            if(error != nil)
            {
                //print("not valid address")
            } else {
                
                let p = CLPlacemark(placemark: placemarks![0])
                
                var lat: CLLocationDegrees = 0
                
                var lon: CLLocationDegrees = 0
                
                
                var subThoroughFare:String = ""
                var thoroughFare:String = ""
                var locality:String = ""
                
                var newAddress = ""
                
                if p.location?.coordinate.latitude != nil{
                    
                    lat = (p.location?.coordinate.latitude)!
                    
                    //print(lat)
                    
                }
                
                if p.location?.coordinate.longitude != nil{
                    
                    lon = (p.location?.coordinate.longitude)!
                    //print(lon)
                }
                
                if (p.subThoroughfare != nil){
                    
                    subThoroughFare = p.subThoroughfare!
                }
                
                if (p.thoroughfare != nil){
                    
                    thoroughFare = p.thoroughfare!
                }
                if (p.locality != nil){
                    
                    locality = p.locality!
                }
                
                if thoroughFare != "" && subThoroughFare != "" {
                    
                    newAddress = "\(subThoroughFare) \(thoroughFare), \(locality)"
                    
                } else if thoroughFare != ""{
                    
                    newAddress = "\(thoroughFare), \(locality)"
                    
                    
                } else {
                    
                    newAddress = "\(locality)"
                    
                }
                
                let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
                
                //print(lat)
                //print(lon)
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                annotation.title = "\(title): \(time)-\(endTime)"
                
                annotation.subtitle = newAddress
                
                pop.popUpAddress = newAddress;
                
                self.map.addAnnotation(annotation);
    
            }
        })
        
        
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("demo")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "demo")
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
      
        
        let pinImage = UIImage(named: "customAnnotation.png")
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContext(size)
        pinImage!.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        annotationView?.image = resizedImage
        
        return annotationView
        
    }
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
    }
    
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print(locations)

        deleteAllAnnotations()//deleteAllPopUps() too
        updatePopUps()
        
        let userLocation: CLLocation = locations[0]
        
        if(activeCoordinate == -1){
            
            let latitude = userLocation.coordinate.latitude
            
            let longitude = userLocation.coordinate.longitude
            
            let latDelta:CLLocationDegrees = 0.1; //zoom
            
            let lonDelta:CLLocationDegrees = 0.1; //zoom
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta); //map span using zooms
            
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            self.map.setRegion(region, animated: false)
            
            self.map.showsUserLocation = true
        } else {
            let address = popUps[activeCoordinate].popUpAddress
            let geocoder: CLGeocoder = CLGeocoder()     //optimize this
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if error != nil{
                    print(error as Any)
                } else {
                    let p = CLPlacemark(placemark: placemarks![0])
                    
                    var lat: CLLocationDegrees = 0;
                    var lon: CLLocationDegrees = 0;
                    
                    if p.location?.coordinate.latitude != nil{
                        
                        lat = (p.location?.coordinate.latitude)!
                    }
                    if p.location?.coordinate.longitude != nil{
                        
                        lon = (p.location?.coordinate.longitude)!
                    }
                    let coordinate = CLLocationCoordinate2DMake(lat, lon)
                    
                    let latDelta:CLLocationDegrees = 0.01
                    let lonDelta:CLLocationDegrees = 0.01
                    
                    let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
                    
                    let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
                    
                    self.map.setRegion(region, animated: false)
                    
                    self.map.showsUserLocation = true
                }
            })
        }
    }
    
    
    
    
}

