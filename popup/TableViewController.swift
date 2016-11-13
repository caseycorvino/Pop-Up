//
//  TableViewController.swift
//  PopUp
//
//  Created by Code on 10/25/16.
//  Copyright © 2016 PopUp. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation

class TableViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        sleep(1)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    
    @IBOutlet var PopUpList: UITableView!
    
    
    
    internal override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return popUps.count;
    }
    
    
    override func viewWillAppear(animated: Bool) {
        popUps.sortInPlace({$0.popUpTime < $1.popUpTime})
        PopUpList.reloadData();
    }
    
    
    var locationManager = CLLocationManager()
    
    
    internal override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        cell.address.text = "      " + popUps[indexPath.row].popUpAddress;
        cell.title.text = "    " + popUps[indexPath.row].popUpTitle;
        cell.startTime.text = popUps[indexPath.row].getPopUpTimeStr();
        
        
        let location2: CLLocation = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        let location1: CLLocation = CLLocation(latitude: popUps[indexPath.row].lat, longitude: popUps[indexPath.row].lon)
        
        let distanceInMeters = location1.distanceFromLocation(location2)
        
        let distanceInKilometer = distanceInMeters / 1000
        
        let distanceInMiles = distanceInKilometer * 1.60934
        
        let distance = Double(round(10*distanceInMiles)/10)
        
        cell.distanceToPerson.text = "\(distance)mi";
        
        
        return cell;
        
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        activeCoordinate = indexPath.row
        
        return indexPath
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}













//    func sortPopUpArray()-> Void{
//
//        //get popups from backendless
//
//        var arr: [PopUp] = [PopUp]()
//            arr = popUps;
//        var sorted: [PopUp] = [PopUp]();
//
//        for _ in 0 ..< 20 {
//            if(arr.count > 0){
//                var smallest: PopUp = arr[0]
//                var index: Int = 0;
//                for j in 0..<arr.count{
//                    if(arr[j].getPopUpTimeStr() < smallest.getPopUpTimeStr()){
//                        smallest = arr[j]
//                        index = j
//                    }
//                }
//                sorted.append(smallest)
//                arr.remove(at: index)
//            }
//        }
//
//        popUps = sorted
//    }

// 1000 5th Ave, New York, NY 10028

