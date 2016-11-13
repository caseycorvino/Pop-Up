//
//  AddPopUpViewController.swift
//  BasicPopUp
//
//  Created by Code on 10/24/16.
//  Copyright © 2016 caseycorvino. All rights reserved.
//

import UIKit

import MapKit

import CoreLocation


class AddPopUpViewController:UIViewController, UITextViewDelegate{
    
    
    
    
    @IBOutlet var popUpTitle: UITextField!
    
    @IBOutlet var popUpAddress: UITextField!
    
    @IBOutlet var hour: UITextField!
    
    @IBOutlet var minute: UITextField!
    
    @IBOutlet var ampm: UITextField!
    
    
    
    @IBOutlet var hour2: UITextField!
    
    @IBOutlet var minute2: UITextField!
    
    @IBOutlet var ampm2: UITextField!
    
    @IBOutlet var desc: UITextView!
    
    
    
    @IBOutlet var warning: UILabel!
    
    @IBOutlet var warning2: UILabel!
    
    @IBOutlet var warning3: UILabel!
    
    @IBOutlet var warning4: UILabel!
    
    @IBOutlet var warning5: UILabel!
    
    var timeInt: Int = 0;
    
    var timeInt2: Int = 0;
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warning.text = ""
        warning2.text = ""
        warning3.text = ""
        warning4.text = ""
        warning5.text = ""
        
        desc.text = "Description:  Please include contact info, website, fees, age requirement, dress code, etc.";
        desc.textColor = UIColor.lightGrayColor()
        self.desc.delegate = self
        
        
        
        
        //print(popUps.count)
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if textView.text == "Description:  Please include contact info, website, fees, age requirement, dress code, etc."{
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func  textViewDidEndEditing(textView: UITextView) {
        if textView.text == ""{
            textView.text = "Description:  Please include contact info, website, fees, age requirement, dress code, etc.";
            desc.textColor = UIColor.lightGrayColor()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        activeCoordinate = -1;
    }
    @IBAction func AddPopUp(sender: AnyObject) {
        activeCoordinate = -1;
        
        let popUpTitleString = popUpTitle.text
        
        let popUpAddressString = popUpAddress.text
        
        let hr: String = hour.text!
        
        let min:String = minute.text!
        
        let ap: String = ampm.text!
        
        let hr2 :String = hour2.text!
        
        let min2:String = minute2.text!
        
        let ap2: String = ampm2.text!
        
        //add popUpProperties
        _ = isValidTitle(popUpTitleString!)
        
        _ = isValidLengthAddress(popUpAddressString!)
        
        warning3.text = timeToInt(hr,min: min,ap: ap);
        
        warning4.text = timeToInt2(hr2, min: min2, ap: ap2);
        
        var validTime: Bool = false
        
        var validTime2: Bool = false
        
        if timeToInt(hr, min: min, ap: ap) == ""{
            validTime = true;
        }
        
        if timeToInt2(hr2, min: min2, ap: ap2) == ""{
            validTime2 = true;
        }
        
        if(timeInt >= timeInt2){
            timeInt2 += 1440
        }
        
        
        let geocoder: CLGeocoder = CLGeocoder()
        
        if isValidTitle(popUpTitleString!) && isValidLengthAddress(popUpAddressString!) && validTime && validTime2{
            geocoder.geocodeAddressString(popUpAddressString!)  { (placemark, error) in
                
                if error != nil {
                    
                    print("Not valid address")
                    
                    self.warning2.text = "Not valid address"
                    
                }
                else {
                    
                    let lat = Double( (placemark![0].location?.coordinate.latitude)!)
                    
                    let lon = Double( (placemark![0].location?.coordinate.longitude)!)
                    
                    let newPopUp = PopUp()
                    
                    newPopUp.popUpTitle = popUpTitleString!
                    newPopUp.popUpAddress = popUpAddressString!
                    newPopUp.popUpTime = self.timeInt
                    newPopUp.popUpEndTime = self.timeInt2
                    newPopUp.lat = lat;
                    newPopUp.lon = lon;
                    newPopUp.desc = self.desc.text
                    //change the desc
                    
                    popUps.append(newPopUp)
                    
                   
                    self.backendless.persistenceService.of(PopUp.ofClass()).save(newPopUp)
                    
//                    Types.tryblock({
//                        self.backendless.persistenceService.of(PopUp.ofClass()).save(newPopUp)
//                        }, catchblock: { (error) -> Void in
//                            print("server reported an error: \(error)")
//                    })
                    //print("Time: \(self.timeInt)")
                    self.performSegueWithIdentifier("back", sender: nil)
                    
                    //print(popUps.count)
                    
                }
            }
        }
        
    }
    
    
    
    func timeToInt(hr: String, min: String, ap: String) -> String {
        var value: Int = 0 ;
        
        if var hrNum: Int = Int(hr) {
            if(hrNum < 13 && hrNum > 0)
            {
                if(hrNum == 12)
                {
                    hrNum = 0;
                }
                value += hrNum * 60;
            }else{
                return "Not valid time"
            }
        } else {
            return "Not valid time"
        }
        
        if let minNum: Int = Int(min) {
            if(minNum < 60 && minNum >= 0)
            {
                value += minNum;
            }else{
                return "Not valid time"
            }
        } else {
            return "Not valid time"
        }
        
        if ap.lowercaseString == "am" || ap.lowercaseString == "pm"{
            if(ap == "pm"){
                value += 12 * 60
            }
        } else {
            return "Not valid time"
        }
        
        timeInt = value;
        
        return ""
    }
    
    func timeToInt2(hr: String, min: String, ap: String) -> String {
        var value: Int = 0 ;
        
        if var hrNum: Int = Int(hr) {
            if(hrNum < 13 && hrNum > 0)
            {
                if(hrNum == 12)
                {
                    hrNum = 0;
                }
                value += hrNum * 60;
            }else{
                return "Not valid time"
            }
        } else {
            return "Not valid time"
        }
        
        if let minNum: Int = Int(min) {
            if(minNum < 60 && minNum >= 0)
            {
                value += minNum;
            }else{
                return "Not valid time"
            }
        } else {
            return "Not valid time"
        }
        
        if ap.lowercaseString == "am" || ap.lowercaseString == "pm"{
            if(ap == "pm"){
                value += 12 * 60
            }
        } else {
            return "Not valid time"
        }
        
        timeInt2 = value;
        
        return ""
    }
    
    
    func convertString(str: String) -> Int{
        let num:Int = Int(str)!
        return num
    }
    
    
    
    
    
    func isValidTitle(newTitle: String) -> Bool{
        
        
        
        if newTitle.characters.count > 3 && newTitle.characters.count < 30{
            warning.text = ""
            return true
            
        }  else  {
            if(newTitle.characters.count < 3)
            {warning.text = "Title needs to be longer than 3 characters"}
            if(newTitle.characters.count > 30)
            {warning.text = "Title needs to be shorter than 30 characters"}
            
            
            return false
        }
    }
    
    
    func isValidLengthAddress(newAddress: String) -> Bool {
        
        if newAddress.characters.count > 8 {
            
            warning2.text = ""
            
            return true
            
        }  else  {
            
            warning2.text = "Address needs to be longer than 8 characters"
            
            return false
        }
        
        
        
    }
    
    //    func isValidTime(newTime: String) -> Bool {
    //
    //
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
