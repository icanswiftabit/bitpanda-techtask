//
//  WalletFiatDTO.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Foundation

struct WalletFiatDTO: Decodable {
    struct Attributes: Decodable {
        let name: String
        let fiatSymbol: String
        let balance: String
        
        enum CodingKeys: String, CodingKey {
            case name, balance
            case fiatSymbol = "fiat_symbol"
        }
    }
    
    let id: String
    let attributes: Attributes
}
