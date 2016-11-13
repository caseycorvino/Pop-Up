//
//  PopUp.swift
//  PopUp
//
//  Created by Code on 10/24/16.
//  Copyright © 2016 PopUp. All rights reserved.
//

import Foundation

import MapKit

import CoreLocation

class PopUp: NSObject{
    
    var popUpTitle: String = ""
    
    var popUpAddress: String = ""
    
    var popUpTime: Int = 0
    
    var popUpEndTime: Int = 0
    
    var desc: String = ""
    
    var lat: Double = 0
    
    var lon: Double = 0

    
    //getters
    
    
    func getPopUpTimeStr() -> String{
        var ampm: String = "am";
        var hour: Int = popUpTime / 60;
        //print(hour);
        let minute: Int = popUpTime - (hour * 60);
        if(popUpTime > 720){
            hour -= 12;
            ampm = "pm";
        }
        if(minute == 0){
            if(hour == 0){ return "12:\(minute)0\(ampm)"}
            return "\(hour):\(minute)0\(ampm)"
        }
        //print(minute)
        if(String(minute).characters.count == 1){
            if(hour == 0){ return "12:0\(minute)\(ampm)"}
            return "\(hour):0\(minute)\(ampm)"
        }
        if(hour == 0){ return "12:\(minute)\(ampm)"}
        return "\(hour):\(minute)\(ampm)"
        
    }
    
    func getPopUpEndTimeStr() -> String{
        var tempTime = popUpEndTime
        //print("end time: \(popUpEndTime)");
        if(popUpEndTime > 1440){
            tempTime -= 1440
        }
        
        var ampm: String = "am";
        var hour: Int = popUpEndTime / 60;
        //print(hour);
        let minute: Int = popUpEndTime - (hour * 60);
        if(popUpEndTime > 720 && popUpEndTime<1440){
            
            ampm = "pm";
        }
        if(popUpEndTime > 720){
            hour -= 12;
        }
        if(minute == 0){
            if(hour > 12){ hour-=12}
            if(hour == 0){ return "12:\(minute)0\(ampm)"}
            return "\(hour):\(minute)0\(ampm)"
        }
        //print(minute)
        if(String(minute).characters.count == 1){
            if(hour == 0){ return "12:0\(minute)\(ampm)"}
            return "\(hour):0\(minute)\(ampm)"
        }
        if(hour == 0){ return "12:\(minute)\(ampm)"}
        return "\(hour):\(minute)\(ampm)"
        
    }
    
    //    func getDistanceFromUser() -> Int{
    //        Todo: implement
    //    }
    
    
}
