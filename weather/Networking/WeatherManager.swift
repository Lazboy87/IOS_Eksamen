//
//  WeatherManager.swift
//  weather
//
//  Created by Lasse Hovden on 24/11/2020.
//

import Foundation
import Alamofire

class WeatherManager {
    
    static func getWeatherData(latitude: Double, longitude: Double, completionHandler: @escaping (_ result:Response?) -> Void) {
        
        let headers: HTTPHeaders = ["content-type": "application/json"]

        AF.request(BASE_URL + "compact?lat=\(latitude)&lon=\(longitude)", method: .get, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (responseData) in switch responseData.result {
            
        case .success( _):
            if(responseData.data != nil)
            {
                do {
                    let decoder = JSONDecoder()
                    let onBoardingResponse = try decoder.decode(Response.self, from:
                        responseData.data!)
                    completionHandler(onBoardingResponse)
                } catch let parsingError {
                    print("Error", parsingError)
                    completionHandler(nil)
                }
            }
            else
            {
                completionHandler(nil)
            }
            
        case .failure(let error):
            print(error.localizedDescription)
            completionHandler(nil)
            }
        }
    }

}
