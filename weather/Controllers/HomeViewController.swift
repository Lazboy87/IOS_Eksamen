//
//  HomeViewController.swift
//  weather
//
//  Created by Lasse Hovden on 24/11/2020.
//

import UIKit
import CoreLocation
import Lottie

class HomeViewController: BaseViewController {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherAnimationView: AnimationView!
    @IBOutlet weak var weatherDescLbl: UILabel!
    @IBOutlet weak var lastUpdatedTimeLbl: UILabel!
    @IBOutlet weak var noDataView: UIView!
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    var summaryList: [WeatherSummary] = []
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataView.isHidden = false
        weatherAnimationView.isHidden = true
        weatherAnimationView.loopMode = .loop

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
        locationManager.requestLocation()
    }

    private func setUpView() {
        
        if (summaryList.isEmpty) {
            return
        }
        
        let summary = summaryList[currentIndex]
        dateLbl.text = summary.date?.getDateString(format: "EEEE")
        weatherDescLbl.text = summary.weatherTypeDescription
        lastUpdatedTimeLbl.text = UserDefinedConfigs.getLastUpdatedTime()?.getDateString(format: "dd/MM/yyyy HH:mm")
        
        if (WeatherType.Rainy.keyWords.contains(summary.symbol_code ?? "N/A")) {
            weatherImageView.isHidden = true
            weatherAnimationView.isHidden = false
            weatherAnimationView.animation = Animation.named("rain")
            weatherAnimationView.play()
        } else {
            weatherAnimationView.isHidden = true
            weatherImageView.isHidden = false
            weatherImageView.image = summary.weatherTypeImg
        }
        noDataView.isHidden = true
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                let next = currentIndex - 1
                currentIndex = next < 0 ? 0 : next
            case .left:
                let next = currentIndex + 1
                currentIndex = next == summaryList.count ? currentIndex : next
            default:
                break
            }
            
            setUpView()
        }
    }
    
    @IBAction func refreshData(_ sender: Any) {
        
        if (isConnectedToInternet()) {
            fetchWeatherData(showActivityIndicator: true)
        }
    }
    
    private func fetchWeatherData(showActivityIndicator: Bool = false) {
                
        if (showActivityIndicator) {
            self.showActivityIndicator()
        }
        
        guard let coordinate = currentLocation?.coordinate else {
            self.locationManager.requestLocation()
            return
        }
        
        WeatherManager.getWeatherData(latitude: coordinate.latitude, longitude: coordinate.longitude) { (response) in
            self.hideActivityIndicator()
            
            if (response == nil && self.summaryList.isEmpty) {
                self.showAlert(message: "Oops! Something went wrong. Please try again")
                self.noDataView.isHidden = false
                
            } else if let data = response?.properties?.timeseries {
                self.filterDataForUse(dataSet: data)
                
                
                UserDefinedConfigs.setCurrentLocation(coordinates: coordinate)
            }
        }
    }
    
    private func filterDataForUse(dataSet: [TimeSeries]) {
        
        self.currentIndex = 0
        self.summaryList = []
        
        var filteredData = dataSet
        filteredData.removeAll(where: {$0.timeObj.timeIntervalSinceNow.sign == .minus})
        
        filteredData.forEach { (timeSeries) in
            if var summary = timeSeries.data?.next_6_hours?.summary {
                summary.date = timeSeries.timeObj
                
                if (!self.summaryList.contains(where: {$0.date?.getDateString(format: "dd/mm/yyyy") == summary.date?.getDateString(format: "dd/mm/yyyy")})) {
                    self.summaryList.append(summary)
                }
            }
        }
        
        
        UserDefinedConfigs.setWeatherData(data: filteredData)
        self.setUpView()
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        fetchWeatherData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
