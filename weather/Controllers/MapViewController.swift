//
//  MapViewController.swift
//  weather
//
//  Created by Lasse Hovden on 26/11/2020.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: BaseViewController {

    @IBOutlet weak var userLocationSwitch: UISwitch!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var weatherTypeImg: UIImageView!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var precipitationAmountLbl: UILabel!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = userLocationSwitch.isOn
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTapedOnMap))
        mapView.addGestureRecognizer(gestureRecognizer)

        clearLocationDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestLocation()
        clearLocationDetails()
    }
    
    @IBAction func toggleUserLocation(_ sender: Any) {
        mapView.showsUserLocation = userLocationSwitch.isOn
    }
    
    @objc func userTapedOnMap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        clearLocationDetails()
        
        if (isConnectedToInternet()) {
            fetchWeatherData(coordinate: coordinate)
        }
    }
    
    private func clearLocationDetails() {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.detailsView.isHidden = true
    }
    
    private func fetchWeatherData(coordinate: CLLocationCoordinate2D) {
        
        if (isConnectedToInternet()) {
            self.showActivityIndicator()

            WeatherManager.getWeatherData(latitude: coordinate.latitude, longitude: coordinate.longitude) { (response) in
                self.hideActivityIndicator()
                
                if (response == nil) {
                    self.showAlert(message: "Oops! Something went wrong. Please try again")
                    
                } else if let data = response?.properties?.timeseries?.first {
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    let precipitationAmount = data.data?.next_6_hours?.details?.precipitation_amount ?? 0
                    
                    self.weatherTypeImg.image = data.data?.next_6_hours?.summary?.weatherTypeImg
                    self.longitudeLbl.text = String(format:"%.5f", coordinate.longitude)
                    self.latitudeLbl.text = String(format:"%.5f", coordinate.latitude)
                    self.precipitationAmountLbl.text = precipitationAmount > 0 ? "\(precipitationAmount) mm" : nil
                    self.detailsView.isHidden = false
                }
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        
        guard let coordinate = currentLocation?.coordinate else { return }
        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(viewRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

