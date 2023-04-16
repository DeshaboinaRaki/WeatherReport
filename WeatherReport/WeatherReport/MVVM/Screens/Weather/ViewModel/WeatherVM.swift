//
//  WeatherVM.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import Foundation

class WeatherVM {
   var weatherManager = WeatherManager()
    var weatherModel = WeatherModel()
    var onCompleted:((WeatherModel)->())?
    var onErrorResponse:((APIError)->())?
    var onImageComp: ((Data)->())?
    
    func getWeatherDetails(searchPlace:String) {
        weatherManager.weatherResponse(place: searchPlace) { (result) in
            switch result {
            case .success(let response):
                guard (response != nil) else {
                    self.onErrorResponse?(APIError.requestFailed)
                    return
                }
                self.weatherModel = response!
                self.onCompleted?(self.weatherModel)
                
                
            case .failure(let error):
                self.onErrorResponse?(error)
            }
        }
    }
    
    func  displayDate(dateStr:Int)->String{
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let newDate = Date(timeIntervalSince1970: Double(dateStr))
        let dates = dateFormatter.string(from: newDate)
        print(dates)
        
     return dates
    }
    
    func  displayTime(dateStr:Int)->String{
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH mm"
        let newDate = Date(timeIntervalSince1970: Double(dateStr))
        let dates = dateFormatter.string(from: newDate)
        print(dates)
        
     return dates
    }
    
    func imageDisplay(id:String){
        weatherManager.imageResponse(icon: id) { (result) in
            
            switch result {
            case .success(let response):
                self.onImageComp?(response)
            case .failure(let error):
                self.onErrorResponse?(error)
                
            }
        }
    }
}
