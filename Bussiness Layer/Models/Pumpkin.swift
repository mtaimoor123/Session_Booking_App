//
//  Pumpkin.swift
//  PumpkinPal
//
//  Created by Munib Hamza on 11/04/2023.
//

import Foundation

// MARK: - Pumpkin
struct Pumpkin: Codable {
    var id: Int?
    var created, modified, name, variety: String?
    var plantingDate, harvestDate, notes: String?
    var user: Int?
    var image, pollinationDate : String?

    enum CodingKeys: String, CodingKey {
        case id, created, modified, name, variety
        case plantingDate = "planting_date"
        case harvestDate = "harvest_date"
        case pollinationDate = "pollination_date"
        case notes, user, image
    }
}

struct Measurement : Codable {
    var id, pumpkin: Int?
    var created, modified, unit, notes: String?
    var sideToSide, endToEnd, circumference : Float?

    enum CodingKeys: String, CodingKey {
        case id, created, modified, unit
        case sideToSide = "side_to_side"
        case endToEnd = "end_to_end"
        case circumference, pumpkin, notes
    }
}
