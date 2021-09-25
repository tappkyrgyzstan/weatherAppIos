//
//  NetworkRoute.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 21/9/21.
//

// api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

import Foundation

enum NetworkRoute {
    
  
    case byLocation(_ lng: Double, _ lat: Double, _ appid: String, _ unit: String)
    case byCityName(_ cityName: String, _ appid: String, _ unit: String)
    case getForecast(_ lat: Double, _ lng: Double, _ exclude: String, _ unit: String, _ appid: String)
    
    
    var schema: API {
        switch self {
        case .byLocation, .byCityName, .getForecast:
            return .schema
        }
    }
    
    var host: API {
        switch self {
        case .byLocation, .byCityName, .getForecast:
            return .host
        }
    }
    
    var path: String {
        switch self {
        case .byLocation, .byCityName:
            return "/data/2.5/weather"
        case .getForecast:
            return "/data/2.5/onecall"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .byLocation(let lng, let lat, let appid, let unit):
            return [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lng)),
            URLQueryItem(name: "units", value: unit),
            URLQueryItem(name: "appid", value: appid),
           
            ]
        case .byCityName(let cityName, let appid, let unit):
            return [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "units", value: unit),
            URLQueryItem(name: "appid", value: appid)
            ]
        case .getForecast(let lat, let lng, let exclude, let unit, let appid):
            return [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lng)),
            URLQueryItem(name: "exclude", value: exclude),
            URLQueryItem(name: "units", value: unit),
            URLQueryItem(name: "appid", value: appid)
            ]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .byLocation, .byCityName, .getForecast:
            return .get
        }
    }
}
