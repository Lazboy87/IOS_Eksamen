//
//  WeatherReportTableViewCell.swift
//  weather
//
//  Created by Lasse Hovden on 24/11/2020.
//

import UIKit

class WeatherReportTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var weatherDetailLbl: UILabel!
    @IBOutlet weak var weatherDetailValueLbl: UILabel!
    @IBOutlet weak var weatherTypeImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
