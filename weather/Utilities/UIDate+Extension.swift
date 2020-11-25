//
//  UIDate+Extension.swift
//  weather
//
//  Created by Lasse Hovden on 25/11/2020.
//

import Foundation

extension Date {
    
    func getRelativeTime(withTime: Bool = true)-> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        if (!withTime) {
            return "\(dateFormatter.string(from: self))"
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        timeFormatter.dateFormat = "h:mm a"

        return "\(dateFormatter.string(from: self)), \(timeFormatter.string(from: self))"
    }
    
    func getDateString(format: String)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    init(fromString: String, format: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        self = dateFormatter.date(from: fromString) ?? Date()
    }
}
