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
    let iconLightUrl: URL?
    
    init(fiat: WalletFiatDTO, iconLightUrl: URL?) {
        self.name = fiat.attributes.name
        self.balance = fiat.attributes.balance
        self.fiatSymbol = fiat.attributes.fiatSymbol
        self.iconLightUrl = iconLightUrl
    }
}
