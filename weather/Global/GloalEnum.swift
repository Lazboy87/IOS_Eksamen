//
//  GloalEnum.swift
//  weather
//
//  Created by Lasse Hovden on 24/11/2020.
//

import UIKit

enum WeatherType: String, CaseIterable {
    case Rainy = "rain"
    case Cloudy = "cloudy"
    case Fair = "fair"
    case Clear = "clear"
    case none
    
    var dayDescriptionText: String {
        switch self {
        case .Rainy:
            return "Rainy today, bring an umbrella"
        case .Cloudy:
            return "Cloudy today, better have an umbrella"
        case .Fair, .Clear:
            return "Sunny today, no umbrella needed"
        case .none:
            return ""
        }
    }
    
    var nightDescriptionText: String {
        switch self {
        case .Rainy:
            return "Rainy night, bring an umbrella"
        case .Cloudy:
            return "Cloudy night, better have an umbrella"
        case .Fair, .Clear:
            return "Clear night, no umbrella needed"
        case .none:
            return ""
        }
    }
    
    var keyWords: [String] {
        switch self {
        case .Rainy:
            return ["heavyrain", "heavyrainandthunder", "heavyrainshowers_day", "heavyrainshowers_night", "heavyrainshowers_polartwilight", "heavyrainshowersandthunder_day", "heavyrainshowersandthunder_night", "heavyrainshowersandthunder_polartwilight", "lightrain", "lightrainandthunder", "lightrainshowers_day", "lightrainshowers_night", "lightrainshowers_polartwilight", "lightrainshowersandthunder_day", "lightrainshowersandthunder_night", "lightrainshowersandthunder_polartwilight", "rain", "rainandthunder", "rainshowers_day", "rainshowers_night", "rainshowers_polartwilight", "rainshowersandthunder_day", "rainshowersandthunder_night", "rainshowersandthunder_polartwilight"]
        default:
            return []
        }
    }
}
