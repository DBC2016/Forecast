//
//  ViewController.swift
//  Forecast
//
//  Created by Demond Childers on 5/16/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    var dataManager = DataManager.sharedInstance
    var networkManager = NetworkManager.sharedInstance
    
    @IBOutlet private weak var forecastSearchBar :UISearchBar!
    
    
    
 
    
    //MARK: - Data View Methods
    
    
    
    
    
    
    
    
    
    
    
    
    
    func newDataRecv() {
        print("DM Temp: \(dataManager.currentWeather.weatherTemp)")
    
    }
    
    
    
    
    @IBAction private func getButtonPressed(sender: UIBarButtonItem) {
        if networkManager.serverAvailable {
            if let address = forecastSearchBar.text {
                dataManager.geoCoder(address)
                //dataManager.getDataFromServer("42,-83")
            } else {
                print("Server Not Available at Get")
            }
            
        }
    }
    

    
    
    
    //MARK: - Life Cycle Methods
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newDataRecv), name: "recvNewDataFromServer", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

