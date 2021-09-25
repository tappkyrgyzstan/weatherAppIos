//
//  GeneralModel.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 25/9/21.
//

import Foundation
struct GeneralModel: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
}
