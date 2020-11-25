//
//  UserDefinedConfigs.swift
//  weather
//
//  Created by Lasse Hovden on 25/11/2020.
//


import Foundation
import CoreLocation

class UserDefinedConfigs {
    
    static let defaults = UserDefaults.standard
    static let savedWeatherData = "weatherData"
    static let currentLocation = "currentLocation"
    static let lastUpdatedTime = "lastUpdatedTime"

    //UserDefaults
    static func setWeatherData(data: [TimeSeries]) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            defaults.set(jsonString, forKey: savedWeatherData)
            setLastUpdatedTime()
        } catch {
            print(error)
        }
    }
    
    static func getWeatherData()-> [TimeSeries] {
        do {
            let jsonString = defaults.string(forKey: savedWeatherData) ?? ""
            let jsonData = Data(jsonString.utf8)
            let decoded = try JSONDecoder().decode([TimeSeries].self, from: jsonData)
            return decoded
        } catch {
            print(error)
        }
        
        return []
    }
    
    static func setCurrentLocation(coordinates: CLLocationCoordinate2D) {
        defaults.set([coordinates.longitude, coordinates.latitude], forKey: currentLocation)
    }
    
    static func getCurrentLocation()-> CLLocationCoordinate2D? {
        var coordinates: CLLocationCoordinate2D?
        
        if let loc = defaults.array(forKey: currentLocation) as? [Double], loc.count == 2 {
            coordinates = CLLocationCoordinate2D(latitude: loc.last!, longitude: loc.first!)
        }
        return coordinates
    }
    
    static func setLastUpdatedTime() {
        defaults.set(Date().timeIntervalSince1970, forKey: lastUpdatedTime)
    }
    
    static func getLastUpdatedTime()-> Date? {
        let timeStamp = defaults.double(forKey: lastUpdatedTime)
        return Date(timeIntervalSince1970: timeStamp)
    }
    
    static func clearUserDefinedConfigs() {
        if let identifier = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: identifier)
            UserDefaults.standard.synchronize()
        }
    }
}
