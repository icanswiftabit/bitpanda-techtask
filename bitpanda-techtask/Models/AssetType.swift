//
//  AssetType.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 11/04/2021.
//

import Foundation

enum AssetType: Int, CaseIterable, CustomStringConvertible {
    case cryptos, commodities, fiats
    
    var description: String {
        switch self {
        case .cryptos: return "Cryptos"
        case .commodities: return "Commodities"
        case .fiats: return "Fiats"
        }
    }
}
