//
//  JsonMasterdata.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Foundation

struct JsonMasterdata: Decodable {
    let cryptoAssets: [AssetCryptoDTO]
    let fiatAssets: [AssetFiatDTO]
    let commodityAssets: [AssetCommodityDTO]
    let wallets: [WalletDTO]
    let fiatWallets: [WalletFiatDTO]
    let commodityWallets: [WalletCommodityDTO]
    
    enum DataKeys: String, CodingKey {
        case data
    }
    
    enum AttributesKeys: String, CodingKey {
        case attributes
    }
    
    enum AssetKeys: String, CodingKey {
        case cryptoAssets = "cryptocoins"
        case fiatAssets = "fiats"
        case commodityAssets = "commodities"
        case wallets = "wallets"
        case fiatWallets = "fiatwallets"
        case commodityWallets = "commodity_wallets"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKeys.self)
        let attributes = try container.nestedContainer(keyedBy: AttributesKeys.self, forKey: .data)
        let values = try attributes.nestedContainer(keyedBy: AssetKeys.self, forKey: .attributes)
        self.cryptoAssets = try! values.decode([AssetCryptoDTO].self, forKey: .cryptoAssets)
        self.fiatAssets = try! values.decode([AssetFiatDTO].self, forKey: .fiatAssets)
        self.commodityAssets = try! values.decode([AssetCommodityDTO].self, forKey: .commodityAssets)
        self.wallets = try! values.decode([WalletDTO].self, forKey: .wallets)
        self.fiatWallets = try! values.decode([WalletFiatDTO].self, forKey: .fiatWallets)
        self.commodityWallets = try! values.decode([WalletCommodityDTO].self, forKey: .commodityWallets)
    }
}
