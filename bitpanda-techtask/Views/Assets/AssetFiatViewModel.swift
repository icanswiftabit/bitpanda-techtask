//
//  AssetFiatViewModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 09/04/2021.
//

import Foundation

struct AssetFiatViewModel: AssetViewModelProtocol, Equatable {
    let iconLightUrl: URL?
//    let iconDarkUrl: URL
    let name: String
    let symbol: String
    let hasWallets: Bool
    
    init(fiat: AssetFiatDTO) {
        self.name = fiat.attributes.name
        self.iconLightUrl = URL(string: fiat.attributes.logo)
        self.symbol = fiat.attributes.symbol
        self.hasWallets = fiat.attributes.hasWallets
    }
}
