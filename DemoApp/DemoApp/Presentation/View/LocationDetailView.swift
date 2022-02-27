//
// Created by AUTHOR
// Copyright (c) YEAR AUTHOR. All rights reserved.
//

import Foundation
import UIKit

class LocationDetailView: BaseViewController
{
    var presenter: LocationDetailViewOutput?
    weak var viewModel: LocationDetailViewModelOutput!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblUV: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblDewPoint: UILabel!
    @IBOutlet weak var lblVisibility: UILabel!
    @IBOutlet weak var imvWeather: UIImageView!
    @IBOutlet weak var lblWeatherDesc: UILabel!
    @IBOutlet weak var imvCurrentLocation: UIImageView!
    @IBOutlet weak var imvWind: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        doReloadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    // MARK:
    // MARK:  IBACTIONS
    @IBAction func btnClosePressed(_ sender: Any) {
        presenter?.doClosePressed()
    }
}

extension LocationDetailView: LocationDetailViewInput {
    func doReloadView() {
        lblUV.text = "UV index".localized + ": -"
        imvCurrentLocation.isHidden = !viewModel.getIsCurrentLocation()
        
        guard let data = viewModel.getForcastWeatherData()?.current else {
            lblLocationName.text = "Current Location".localized
            lblTemp.text = "-"
            lblWind.text = "Wind".localized + ": -"
            lblHumidity.text = "Humidity".localized + ": -"
            lblPressure.text = "Pressure".localized + ": -"
            lblVisibility.text = "Visibility".localized + ": -"
            lblDewPoint.text = "Dew point".localized + ": -"
            lblWeatherDesc.text = ""
            imvWeather.image = nil
            imvWind.isHidden = true
            lblLocationName.text = "-"
            lblUV.text = "UV index".localized + ": -"
            return
        }
        
        imvWind.isHidden = false
        imvWind.transform = CGAffineTransform(rotationAngle: CGFloat(data.wind_deg*(Double.pi/180)))
        DLog("windInfor.deg: \(data.wind_deg)")
        
        lblLocationName.text = viewModel?.getLocationName()?.capitalized
        lblTemp.text = String(format: "%.0f°C", data.temp.tempK2C)
        lblWind.text = String(format: "%@: %.1fm/s %@", "Wind".localized, data.wind_speed, data.wind_deg.windDegSymbol)
        lblHumidity.text = "Humidity".localized + ": \(Int(data.humidity))%"
        
        lblPressure.text = "Pressure".localized + ": \(Int(data.pressure))hPa"
        lblVisibility.text = String(format: "%@: %.1fkm", "Visibility".localized, data.visibility/1000)
        lblDewPoint.text = String(format: "%@: %.0f°C", "Dew point".localized , data.dew_point.tempK2C)
        lblUV.text = "UV index".localized + ": \(data.uvi)"
        
        let weather = data.weather.first
        lblWeatherDesc.text = weather?.desc.capitalizingFirstLetter()
        
        if let icon = weather?.icon, !icon.isEmpty {
            imvWeather.image = UIImage(named: icon)
        } else {
            imvWeather.image = nil
        }
    }
}
