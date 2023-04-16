//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import UIKit

class WeatherVC: UIViewController,NormalAlert {
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var cityLbl : UILabel!
    @IBOutlet weak var tempLbl : UILabel!
    @IBOutlet weak var descTempLbl : UILabel!
    @IBOutlet weak var tempImageView : UIImageView!
    @IBOutlet weak var sunriseLbl : UILabel!
    @IBOutlet weak var sunsetLbl : UILabel!
    @IBOutlet weak var humidityLbl : UILabel!
    var weatherVM = WeatherVM()
    var weatherModel = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundColor = .clear
        displayResponse()
    }
    
    func displayWeather(){
        let sunrise = weatherVM.displayTime(dateStr: weatherModel.system?.sunrise ?? 0)
        let sunset = weatherVM.displayTime(dateStr: weatherModel.system?.sunset ?? 0)
        
        let humidity = weatherModel.main?.humidity ?? 0
        
        sunriseLbl.text = sunrise
        sunsetLbl.text = sunset
        humidityLbl.text = String(humidity) + " %"
        
    }
    
    func displayResponse() {
        weatherVM.onCompleted = {[weak self] result in
            print(result)
            self?.weatherModel = result
            DispatchQueue.main.async {
                let dat = self?.weatherVM.displayDate(dateStr: self?.weatherModel.date ?? 0)
                self?.dateLbl.text = dat
                self?.cityLbl.text = self?.weatherModel.name ?? ""
                let celicus  = self?.weatherModel.main?.temperature ?? 0
                let measurement = Measurement(value: celicus, unit: UnitTemperature.celsius)

                let measurementFormatter = MeasurementFormatter()
                measurementFormatter.unitStyle = .short
                measurementFormatter.numberFormatter.maximumFractionDigits = 0
                measurementFormatter.unitOptions = .temperatureWithoutUnit
                let measurementInKelvin = Measurement(value: celicus, unit: UnitTemperature.kelvin)
                let measurements = measurementInKelvin.converted(to: .celsius)
              
                self?.tempLbl.text = measurementFormatter.string(from: measurements)
                
                self?.descTempLbl.text = self?.weatherModel.weather?[0].description ?? ""
                let id = self?.weatherModel.weather?[0].icon ?? ""
                self?.weatherVM.imageDisplay(id:id)
                
                self?.displayWeather()
            }
        }
        weatherVM.onErrorResponse = { error in
            
            DispatchQueue.main.async {
                self.normalAlert(title: alertContent.title, message: error.description, {})
            }
            
        }
       
        
        weatherVM.onImageComp = { data in
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.tempImageView.image = image
                
            }
          
        }
    }
}
extension WeatherVC: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
       weatherVM.getWeatherDetails(searchPlace: searchText)
    }
}

