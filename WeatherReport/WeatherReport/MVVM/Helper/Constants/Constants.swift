//
//  Constants.swift
//  WeatherApp
//
//  Created by Rakesh Deshaboina on 11/04/23.
//

import Foundation

class Path: NSObject {
    static var BaseUrl = "https://api.openweathermap.org"
    
}

class Serviceheader: NSObject {
    static let urlEncoded = ["Content-Type": "application/x-www-form-urlencoded"]
}

class alertContent : NSObject {
    
    static var title = " Weather Alert"
    static var checkSearch = "City Not Found"
}
