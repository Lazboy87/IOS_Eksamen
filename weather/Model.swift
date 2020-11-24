//
//  Model.swift
//  weather
//
//  Created by Lasse Hovden on 24/11/2020.
//

import UIKit

struct Response: Codable {
    var properties: Properties?
}

struct Properties: Codable {
    var meta: MetaData?
    var timeseries: [TimeSeries]?
}

struct MetaData: Codable {
    var units: Units?
}

struct Units: Codable {
    var relative_humidity: String?
    var wind_from_direction: String?
    var wind_speed: String?
    var air_temperature: String?
    var precipitation_amount: String?
    var air_pressure_at_sea_level: String?
    var cloud_area_fraction: String?
}

struct TimeSeries: Codable {
    var time: String?
    var timeObj: Date {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return dateFormatter.date(from: time ?? "") ?? Date()
        }
    }
    var data: TimeSeriesData?
}

struct TimeSeriesData: Codable {
    var instant: WeatherData?
    var next_6_hours: WeatherData?
    var next_1_hours: WeatherData?
    var next_12_hours: WeatherData?
}

struct WeatherData: Codable {
    var summary: WeatherSummary?
    var details: WeatherDetails?
}

struct WeatherDetails: Codable {
    var air_temperature: Double?
    var wind_from_direction: Double?
    var air_pressure_at_sea_level: Double?
    var relative_humidity: Double?
    var cloud_area_fraction: Double?
    var wind_speed: Double?
    
    var precipitation_amount: Double?
}

struct WeatherSummary: Codable {
    var symbol_code: String?
    var weatherTypeDescription: String? {
        get {
            let types = WeatherType.allCases
            let type = types.first(where: {symbol_code?.lowercased().contains($0.rawValue) ?? false})
            
            if (symbol_code?.contains("night") ?? false) {
                return type?.nightDescriptionText
            } else {
                return type?.dayDescriptionText
            }
        }
    }
    var weatherTypeImg: UIImage? {
        get {
            return UIImage(named: symbol_code ?? "")
        }
    }
    var date: Date?
}

