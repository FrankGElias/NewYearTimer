//
//  ZipCodeInfoObject.swift
//  TimeZoneAPI
//
//  Created by Francis Elias on 7/14/20.
//  Copyright © 2020 Frank. All rights reserved.
//

import Foundation

// MARK: Class initialization, conform to Identifiable to get an ObjectIdentifier(id) generated and conform to Decodable to decode JSON instead of using loops to populate our objects

class ZipCodeInfoObject : Identifiable, Decodable {
    
    let id = UUID()
    let zip_code : String?
    let lat : Double?
    let lng : Double?
    let city : String?
    let state : String?
    let timezone : TimeZoneObject?
    let areaCodes : [Int]?
    let error_code : Int?
    let error_msg : String?
}

class TimeZoneObject : Decodable {

    let timezone_identifier : String?
    let timezone_abbr : String?
    let utc_offset_sec : Double?
    var is_dst : String?
}
