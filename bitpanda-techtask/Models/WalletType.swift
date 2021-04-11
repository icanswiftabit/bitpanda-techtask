//
//  WalletType.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 11/04/2021.
//

import Foundation

enum WalletType: Int, CaseIterable, CustomStringConvertible {
    case all, wallets, commodities, fiats
    
    var description: String {
        switch self {
        case .all: return "All"
        case .wallets: return "Wallets"
        case .commodities: return "Commodities"
        case .fiats: return "Fiats"
        }
    }
}
