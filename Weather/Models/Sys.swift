//
//  Sys.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 25/9/21.
//

import Foundation

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
