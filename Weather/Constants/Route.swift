//
//  Route.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 24/9/21.
//

// api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

import Foundation


enum API: String {
    case schema = "http"
    case host = "api.openweathermap.org"
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}


