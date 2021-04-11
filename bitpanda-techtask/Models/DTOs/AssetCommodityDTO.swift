//
//  AssetCommodityDTO.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Foundation

struct AssetCommodityDTO: Decodable {
    struct Attributes: Decodable {
        let name: String
        let logo: String
        let logoDark: String
        let symbol: String
        let avgPrice: String
        let precisionForFiatPrice: Int
        
        enum CodingKeys: String, CodingKey {
            case name, logo, symbol
            case logoDark = "logo_dark"
            case avgPrice = "avg_price"
            case precisionForFiatPrice = "precision_for_fiat_price"
        }
    }
    
    let id: String
    let attributes: Attributes
}
