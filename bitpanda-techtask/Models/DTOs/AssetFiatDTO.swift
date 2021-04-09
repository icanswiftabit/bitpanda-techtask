//
//  AssetFiatDTO.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Foundation

struct AssetFiatDTO: Decodable {
    struct Attributes: Decodable {
        let name: String
        let logo: String
        let symbol: String
        let hasWallets: Bool
        
        enum CodingKeys: String, CodingKey {
            case name, logo, symbol
            case hasWallets = "has_wallets"
        }
        
    }
    
    let id: String
    let attributes: Attributes
}
