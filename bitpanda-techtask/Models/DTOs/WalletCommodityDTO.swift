//
//  WalletCommodityDTO.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Foundation

struct WalletCommodityDTO: Decodable {
    struct Attributes: Decodable {
        let name: String
        let cryptocoinSymbol: String
        let balance: String
        let deleted: Bool
        let isDefault: Bool
        
        enum CodingKeys: String, CodingKey {
            case name, balance, deleted
            case cryptocoinSymbol = "cryptocoin_symbol"
            case isDefault = "is_default"
        }
    }
    
    let id: String
    let attributes: Attributes
}
