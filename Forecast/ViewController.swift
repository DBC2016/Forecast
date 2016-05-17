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
    
    @IBOutlet private weak var forecastSearchBar    :UISearchBar!
    @IBOutlet private weak var forecastTempLabel    :UILabel!
    @IBOutlet private weak var forecastCityLabel    :UILabel!
    @IBOutlet private weak var forecastDateLabel    :UILabel!
    @IBOutlet private weak var forecastSumTextView  :UITextView!
    @IBOutlet private weak var forecastImageView    :UIImageView!
    
    
    
 
    
    //MARK: - Data View Methods

    func newDataRecv() {
        print("reloading data")
        fillEverythingOut()
    }
    
    
//    func newDataRecv() {
//        print("DM Temp: \(dataManager.currentWeather.weatherTemp)")
//    
//    }
//    
    
    func fillEverythingOut() {
        if let currentTemp = dataManager.currentWeather.weatherTemp{
            forecastTempLabel.text = String(currentTemp)
        }
        if let tempDate = dataManager.currentWeather.weatherDate {
            forecastDateLabel.text = String(tempDate)
        }
        if let tempCity = dataManager.currentWeather.weatherCity {
            forecastCityLabel.text = String(tempCity)
        }
        forecastImageView.image = UIImage (named: dataManager.currentWeather.weatherImage)
        if let currentSummary = dataManager.currentWeather.weatherDescript {
            forecastSumTextView.text = "Current Weather Summary: " + currentSummary
        }
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

