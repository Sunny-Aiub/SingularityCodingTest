//
//  Helper.swift
//  SingularityCodingTest
//
//  Created by Sunny Chowdhury on 8/21/20.
//  Copyright © 2020 Sunny Chowdhury. All rights reserved.
//

import Foundation
import UIKit

class Helper: NSObject {
    
    static let BASE_URL = "http://128.199.215.102:4040"
    static let GET_STORE_APISTRING = "/api/stores"
    static let ATTENDENCE_APISTRING = "/api/attendance/"
    static let ERROR_MESSAGE = "Something went wrong"
    
    static func updateUserInterface(vc: UIViewController) {
        switch Network.reachability.status {
        case .unreachable:
        showAlert(title:  "Error!", message: "Internet is not availabel", vc: vc) 
            
        case .wwan: break
        //view.backgroundColor = .yellow
        case .wifi: break
            //view.backgroundColor = .green
        }
        print("Reachability Summary")
        print("Status:", Network.reachability.status)
        print("HostName:", Network.reachability.hostname ?? "nil")
        print("Reachable:", Network.reachability.isReachable)
        print("Wifi:", Network.reachability.isReachableViaWiFi)
    }
    
   
    static func showAlert(title: String , message: String, vc: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alertController, animated: true, completion: nil)
        
    }
}


extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}

extension UIView{
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let superCenter = CGPoint(x: superview!.bounds.midX, y: superview!.bounds.midY)
        //imageView.center = superCenter
        
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width/2, height: self.bounds.height/2)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        backgroundView.center = superCenter
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}
