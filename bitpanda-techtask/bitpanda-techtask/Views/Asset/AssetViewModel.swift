//
//  AssetViewModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import Foundation

struct AssetViewModel {
    struct AveragePrice {
        let price: String
        let precision: Int
    }
    
    let iconLightUrl: URL?
//    let iconDarkUrl: URL
    let name: String
    let symbol: String
    let avgPrice: AveragePrice?
    
    init(crypto: AssetCryptoDTO) {
        self.name = crypto.attributes.name
        self.iconLightUrl = URL(string: crypto.attributes.logo)
        self.symbol = crypto.attributes.symbol
        self.avgPrice = AveragePrice(price: crypto.attributes.avgPrice, precision: crypto.attributes.precisionForFiatPrice)
    }
    
    init(commodity: AssetCommodityDTO) {
        self.name = commodity.attributes.name
        self.iconLightUrl = URL(string: commodity.attributes.logo)
        self.symbol = commodity.attributes.symbol
        self.avgPrice = AveragePrice(price: commodity.attributes.avgPrice, precision: commodity.attributes.precisionForFiatPrice)
    }
    
    init(fiat: AssetFiatDTO) {
        self.name = fiat.attributes.name
        self.iconLightUrl = URL(string: fiat.attributes.logo)
        self.symbol = fiat.attributes.symbol
        self.avgPrice = nil
    }
}
