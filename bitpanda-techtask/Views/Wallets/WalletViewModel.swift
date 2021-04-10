//
//  WalletViewModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Foundation

struct WalletViewModel: WalletViewModelProtocol, Equatable {
    let name: String
    
    init(wallet: WalletDTO) {
        self.name = wallet.attributes.name
    }
    
    init(commodity: WalletCommodityDTO) {
        self.name = commodity.attributes.name
    }
}
