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
    @IBOutlet weak var windLbl : UILabel!
    @IBOutlet weak var pressureLbl : UILabel!
    @IBOutlet weak var temperatureLbl : UILabel!
    var weatherVM = WeatherVM()
    var weatherModel = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundColor = .clear
       
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .clear
        searchBar.text = "California"
        
        weatherVM.getWeatherDetails(searchPlace: "California")
        
      
      
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
               
                self?.dateLbl.text = self?.weatherVM.date
                self?.cityLbl.text = self?.weatherVM.cityLbl
                
                self?.tempLbl.text = self?.weatherVM.templbl
                
                self?.descTempLbl.text = self?.weatherVM.tempDescp
                let id = self?.weatherModel.weather?[0].icon ?? ""
                self?.weatherVM.imageDisplay(id:id)
                self?.pressureLbl.text = self?.weatherVM.pressureLbl
                self?.humidityLbl.text = self?.weatherVM.humidityLbl
                self?.sunriseLbl.text = self?.weatherVM.sunriseLbl
                self?.sunsetLbl.text = self?.weatherVM.sunsetLbl
                self?.windLbl.text = self?.weatherVM.windLbl
                self?.temperatureLbl.text = self?.weatherVM.temperatureLbl
              
                
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

