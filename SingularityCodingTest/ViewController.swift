//
//  ViewController.swift
//  SingularityCodingTest
//
//  Created by Sunny Chowdhury on 8/21/20.
//  Copyright © 2020 Sunny Chowdhury. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var indicator = UIActivityIndicatorView()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    
    var storeList: [Store] = []
    var url : String = ""
    var nextUrl: String = ""
    var previousUrl: String = ""
    var jsonResponse: StoreListAPResonse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActivityIndicator()
        self.tableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        callAPI()
    }
    
    func setUpActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        callAPI()
        refreshControl.endRefreshing()
    }
    
    func callAPI() {
        #if targetEnvironment(simulator)
        // simulator code
        storeList.removeAll()
        getStoreList(urlString: Helper.BASE_URL + Helper.GET_STORE_APISTRING )
        #else
        // real device code
        if Network.reachability.status == .unreachable{
            Helper.showAlert(title: "Error!", message: "Internet Not Available", vc: self)
            
        }else{
            storeList.removeAll()
            getStoreList(urlString: Helper.BASE_URL + Helper.GET_STORE_APISTRING )
        }
        #endif
        
    }
    
    func getStoreList(urlString: String) {
        //self.showSpinner(onView: self.view)
        print(urlString)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5) // .white
        print(urlString)
        
        AF.request(urlString, method: .get, parameters: nil, encoding:  URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            
            switch(response.result) {
            case.success(let data):
                
                print("success",data)
                let statusCode = response.response?.statusCode
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                
                if statusCode == 200{
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                    let allStores = try? JSONDecoder().decode(StoreListAPResonse.self, from: response.data!)
                    self.jsonResponse = allStores
                    
                    var items: [Store] = self.storeList
                    items.append(contentsOf: (allStores?.data)!)
                    
                    self.storeList.removeAll()
                    self.storeList = items
                    
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        self.indicator.hidesWhenStopped = true
                        self.tableView.reloadData()
                        //self.removeSpinner()
                    }
                    
                }else{
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                    print("error with response status: \(String(describing: statusCode))")
                    Helper.showAlert(title: "Error!", message: response.error?.localizedDescription ?? Helper.ERROR_MESSAGE, vc: self )
                }
                
            case.failure(let error):
                print("Not Success",error.localizedDescription)
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                Helper.showAlert(title: "Error!", message: response.error?.localizedDescription ?? Helper.ERROR_MESSAGE, vc: self )
            }
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row ==  self.storeList.count - 1{
            if self.jsonResponse?.meta?.total != self.storeList.count{
                
                if let nextValue = self.jsonResponse?.links?.next {
                    print(nextValue)
                    self.getStoreList(urlString: nextValue)
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if storeList.count == 0 {
            tableView.setEmptyMessage("No Store Available")
        } else {
            tableView.restore()
        }
        return storeList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.storeList[indexPath.row].name
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if storeList.count > indexPath.row &&  storeList[indexPath.row] != nil{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "AttendenceViewController") as! AttendenceViewController
            //vc.notificationID = notificationList[indexPath.row].notificationID!
            vc.data = storeList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
}

