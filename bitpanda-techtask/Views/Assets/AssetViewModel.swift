//
//  AssetViewModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import Foundation

struct AssetViewModel: AssetViewModelProtocol, Equatable {
    struct AveragePrice: Equatable {
        let price: String
        let precision: Int
    }
    
    let logoAsset: ImageAssetResource
    let name: String
    let symbol: String
    let averagePrice: AveragePrice
    
    init(crypto: AssetCryptoDTO) {
        self.name = crypto.attributes.name
        self.logoAsset = ImageAssetResource(lightUrl: URL(string: crypto.attributes.logo), darkUrl: URL(string: crypto.attributes.logoDark))
        self.symbol = crypto.attributes.symbol
        self.averagePrice = AveragePrice(price: crypto.attributes.avgPrice, precision: crypto.attributes.precisionForFiatPrice)
    }
    
    init(commodity: AssetCommodityDTO) {
        self.name = commodity.attributes.name
        self.logoAsset = ImageAssetResource(lightUrl: URL(string: commodity.attributes.logo), darkUrl: URL(string: commodity.attributes.logoDark))
        self.symbol = commodity.attributes.symbol
        self.averagePrice = AveragePrice(price: commodity.attributes.avgPrice, precision: commodity.attributes.precisionForFiatPrice)
    }
}
