//
//  DataManager.swift
//  Forecast
//
//  Created by Demond Childers on 5/16/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

import UIKit
import CoreLocation


class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    var baseURL = "api.forecast.io"
//    var weatherArray = [Weather]()
    var currentWeather = Weather()
    
    
    
    func geoCoder(addressString: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("\(addressString)") { (placemarks, error) in
            if let placemark = placemarks?[0] {
                guard let addressDict = placemark.addressDictionary else {
                    return
                }
                guard let city = addressDict["City"] else {
                    return
                }
                guard let loc = placemark.location else {
                    return
                }
                print("City: \(city) Lat:\(loc.coordinate.latitude) \(loc.coordinate.longitude)")
                let coords = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
                self.getDataFromServer(coords)
            }
        }
    }
    
    
    func getDataFromServer(coords: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        defer {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        //https://api.forecast.io/forecast/APIKEY/LATITUDE,LONGITUDE
        let url = NSURL(string: "https://\(baseURL)/forecast/515244ad55aed629c903f577ea79f547/\(coords)")
        let urlRequest = NSURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(urlRequest) { (data, response, error) in
            guard let unwrappedData = data else {
                print("No Data")
                return
            }

            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: .MutableContainers)
                print("Json: \(jsonResult)")
                let tempWeatherDict = jsonResult.objectForKey("currently") as! NSDictionary
                self.currentWeather = Weather()
                self.currentWeather.weatherTemp = tempWeatherDict.objectForKey("temperature") as! Double
                self.currentWeather.weatherImage = tempWeatherDict.objectForKey("icon") as! String
                self.currentWeather.weatherDescript = tempWeatherDict.objectForKey("summary") as! String
//                    currWeather.weatherLat = weatherDict.objectForKey("latitude") as! String
//                    currWeather.weatherLon = weatherDict.objectForKey("longitutde") as! String
////                    print("imagename: \(currWeather.weatherImageFilename)")
//                    currWeather.weatherCity = weatherDict.objectForKey("city") as! String
//                    let formatter = NSDateFormatter()
//                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            currWeather.weatherDate = formatter.dateFromString(weatherDict.objectForKey("time") as! String)
                dispatch_async(dispatch_get_main_queue(), {
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "recvNewDataFromServer", object: nil))
                })
                print("Temp:\(self.currentWeather.weatherTemp) Icon:\(self.currentWeather.weatherImage)")
            } catch {
                print("JSON Parsing Error")
                
            }
            
        }
        task.resume()
    }
    
    func fileIsInDocuments(filename: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        return fileManager.fileExistsAtPath(getDocumentPathForFile(filename))
        
    }
    
    func getDocumentPathForFile(filename: String) -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        return documentPath.stringByAppendingPathComponent(filename)
    }
    
    private func getImageFromServer(localFilename: String, remoteFilename: String) {
        let remoteURL = NSURL(string: remoteFilename)
        let imageData = NSData(contentsOfURL: remoteURL!)
        let imageTemp = UIImage(data: imageData!)
        if let _ = imageTemp {
            imageData!.writeToFile(getDocumentPathForFile(localFilename), atomically: false)
        }
        
    }
    
}



//}