//
//  WalletViewModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Foundation

struct WalletViewModel: WalletViewModelProtocol, Equatable {
    let name: String
    let symbol: String
    let balance: String
    let deleted: Bool
    let isDefault: Bool
    let logoAsset: ImageAssetResource
    
    init(wallet: WalletDTO, logoAsset: ImageAssetResource) {
        self.name = wallet.attributes.name
        self.symbol = wallet.attributes.cryptocoinSymbol
        self.balance = wallet.attributes.balance
        self.deleted = wallet.attributes.deleted
        self.isDefault = wallet.attributes.isDefault
        self.logoAsset = logoAsset
    }
    
    init(commodity: WalletCommodityDTO, logoAsset: ImageAssetResource) {
        self.name = commodity.attributes.name
        self.symbol = commodity.attributes.cryptocoinSymbol
        self.balance = commodity.attributes.balance
        self.deleted = commodity.attributes.deleted
        self.isDefault = commodity.attributes.isDefault
        self.logoAsset = logoAsset
    }
}
