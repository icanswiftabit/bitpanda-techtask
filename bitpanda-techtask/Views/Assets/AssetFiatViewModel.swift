//
//  AssetFiatViewModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 09/04/2021.
//

import Foundation

struct AssetFiatViewModel: AssetViewModelProtocol, Equatable {
    let name: String
    let symbol: String
    let hasWallets: Bool
    let logoAsset: ImageAssetResource
    
    init(fiat: AssetFiatDTO) {
        self.name = fiat.attributes.name
        self.logoAsset = ImageAssetResource(lightUrl: URL(string: fiat.attributes.logo), darkUrl: URL(string: fiat.attributes.logoDark))
        self.symbol = fiat.attributes.symbol
        self.hasWallets = fiat.attributes.hasWallets
    }
}
