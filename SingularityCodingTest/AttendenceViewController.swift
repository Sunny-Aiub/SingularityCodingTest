//
//  AttendenceViewController.swift
//  SingularityCodingTest
//
//  Created by Sunny Chowdhury on 8/22/20.
//  Copyright © 2020 Sunny Chowdhury. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class AttendenceViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtID: UITextField!
    
    var data: Store?
    var locationManager = CLLocationManager()
    var myLocation : CLLocationCoordinate2D?
    var uniqueID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMyLocation()
        uniqueID = randomString(length: 12)
        print(uniqueID)
        
    }
    
    func getMyLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        uniqueID = randomString(length: 12)
        print(uniqueID)
        print(myLocation?.latitude)
        
        if myLocation != nil && txtName.text != "" && txtID.text != ""{
            
            callPostAPI()
            
        }else{
            if myLocation == nil {
                Helper.showAlert(title: "No Location Found. Turn on location permission", message: "", vc: self)
                getMyLocation()
                
            }else{
                Helper.showAlert(title: "Error!", message: "Invalid Data", vc: self)
            }
        }
        
    }
    
    func callPostAPI() {
        #if targetEnvironment(simulator)
        // simulator code
        let url: String = Helper.BASE_URL + Helper.ATTENDENCE_APISTRING
        print(url)
        self.handleSubmit(urlString: url)
        #else
        // real device code
        if Network.reachability.status == .unreachable{
            Helper.showAlert(title: "Error!", message: "Internet Not Available", vc: self)
            
        }else{
            let url: String = Helper.BASE_URL + Helper.ATTENDENCE_APISTRING
            print(url)
            self.handleSubmit(urlString: url)
        }
        #endif
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status != .authorizedWhenInUse){
            
            return
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        myLocation = locValue
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        print(coordinations)
        myLocation = coordinations
        
    }
    
    func handleSubmit(urlString: String) {
        
        self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        
        let parameter:Parameters = [
            "name" : txtName.text!,
            "uid" : txtID.text!,
            "latitude" : myLocation?.latitude ?? 0.0,
            "longitude" : myLocation?.latitude ?? 0.0,
            "request_id": uniqueID
            
        ]
        print(parameter)
        print(urlString)
        
        AF.request(urlString, method: .post, parameters: parameter as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
                
                
            case.success(let data):
                self.view.activityStopAnimating()
                print("success",data)
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let attendenceResponse = try? JSONDecoder().decode(AttendenceResponse.self, from: response.data!)
                print(attendenceResponse)
                if statusCode == 200{
                    
                    DispatchQueue.main.async {
                        print(attendenceResponse?.appMessage)
                        print(attendenceResponse?.userMessage)
                        
                        let alertController = UIAlertController(title: attendenceResponse?.appMessage ?? "Success", message: attendenceResponse?.userMessage ?? "Success! Attendance has been given!", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        self.present(alertController, animated: true, completion: nil)

                    }
                }else{
                    Helper.showAlert(title:  attendenceResponse?.appMessage ?? "Error!", message: attendenceResponse?.userMessage ?? Helper.ERROR_MESSAGE, vc: self)
                }
                
            case.failure(let error):
                print("Not Success",error)
                Helper.showAlert(title: "Error!", message: response.error?.localizedDescription ?? Helper.ERROR_MESSAGE, vc: self)
            }
        }
        
        self.view.activityStopAnimating()
    }
    
}
