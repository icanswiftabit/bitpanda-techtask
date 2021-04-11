//
//  WalletFiatViewModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Foundation

struct WalletFiatViewModel: WalletViewModelProtocol, Equatable {
    let name: String
    let fiatSymbol: String
    let balance: String
    let logoAsset: ImageAssetResource
    
    init(fiat: WalletFiatDTO, logoAsset: ImageAssetResource) {
        self.name = fiat.attributes.name
        self.balance = fiat.attributes.balance
        self.fiatSymbol = fiat.attributes.fiatSymbol
        self.logoAsset = logoAsset
    }
}
