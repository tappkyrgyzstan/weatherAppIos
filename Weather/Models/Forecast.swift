//
//  Forecast.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 25/9/21.
//

import Foundation

struct Forecast : Codable {
    let lat : Double?
    let lon : Double?
    let timezone : String?
    let timezone_offset : Int?
    let daily : [Daily]?

    enum CodingKeys: String, CodingKey {

        case lat = "lat"
        case lon = "lon"
        case timezone = "timezone"
        case timezone_offset = "timezone_offset"
        case daily = "daily"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lon = try values.decodeIfPresent(Double.self, forKey: .lon)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
        timezone_offset = try values.decodeIfPresent(Int.self, forKey: .timezone_offset)
        daily = try values.decodeIfPresent([Daily].self, forKey: .daily)
    }
}
