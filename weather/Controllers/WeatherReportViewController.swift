//
//  WeatherReportViewController.swift
//  weather
//
//  Created by Lasse Hovden on 24/11/2020.
//

import UIKit

class WeatherReportViewController: UIViewController {

    @IBOutlet weak var weatherReportTableView: UITableView!
    @IBOutlet weak var locationLbl: UILabel!
    
    var dataSet: [TimeSeries] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
    }
    
    private func setUpView() {
        
        guard let data = UserDefinedConfigs.getWeatherData().first else { return }
        dataSet = [data]
        weatherReportTableView.reloadData()
        
        if let location = UserDefinedConfigs.getCurrentLocation() {
            self.locationLbl.text = "\(String(format:"%.5f", location.longitude)),\(String(format:"%.5f", location.longitude))"
        } else {
            self.locationLbl.text = "N/A"
        }
    }
}

extension WeatherReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {   
        return 4
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherReportTableViewCell") as! WeatherReportTableViewCell
        let timeSeries = dataSet[indexPath.section]

        cell.weatherDetailLbl.text = "Weather"
        cell.weatherDetailValueLbl.text = nil
        cell.weatherTypeImgView.image = nil
        
        switch indexPath.row {
        case 0:
            cell.timeLbl.text = "Now"
            cell.weatherDetailLbl.text = "Temperature"
            cell.weatherDetailValueLbl.text = "\(timeSeries.data?.instant?.details?.air_temperature ?? 0) ºC"
        case 1:
            cell.timeLbl.text = "Next Hour"
            cell.weatherTypeImgView.image = timeSeries.data?.next_1_hours?.summary?.weatherTypeImg
            
            let precipitationAmount = timeSeries.data?.next_1_hours?.details?.precipitation_amount ?? 0
            cell.weatherDetailValueLbl.text = precipitationAmount > 0 ? "\(precipitationAmount) mm" : nil
        case 2:
            cell.timeLbl.text = "Next 6 Hours"
            cell.weatherTypeImgView.image = timeSeries.data?.next_6_hours?.summary?.weatherTypeImg

            let precipitationAmount = timeSeries.data?.next_6_hours?.details?.precipitation_amount ?? 0
            cell.weatherDetailValueLbl.text = precipitationAmount > 0 ? "\(precipitationAmount) mm" : nil
        case 3:
            cell.timeLbl.text = "Next 12 Hours"
            cell.weatherTypeImgView.image = timeSeries.data?.next_12_hours?.summary?.weatherTypeImg

            let precipitationAmount = timeSeries.data?.next_12_hours?.details?.precipitation_amount ?? 0
            cell.weatherDetailValueLbl.text = precipitationAmount > 0 ? "\(precipitationAmount) mm" : nil
        default:
            fatalError("Invalid section data count")
        }
        
        return cell
    }
}
