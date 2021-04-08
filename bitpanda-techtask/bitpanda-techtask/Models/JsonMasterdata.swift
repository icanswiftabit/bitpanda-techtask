//
//  JsonMasterdata.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Foundation

struct JsonMasterdata: Decodable {
    let assetCryptos: [AssetCryptoDTO]
    let assetFiats: [AssetFiatDTO]
    let assetCommodities: [AssetCommodityDTO]
    
    enum DataKeys: String, CodingKey {
        case data
    }
    
    enum AttributesKeys: String, CodingKey {
        case attributes
    }
    
    enum AssetKeys: String, CodingKey {
        case assetCryptos = "cryptocoins"
        case assetFiats = "fiats"
        case assetCommodities = "commodities"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKeys.self)
        let attributes = try container.nestedContainer(keyedBy: AttributesKeys.self, forKey: .data)
        let values = try attributes.nestedContainer(keyedBy: AssetKeys.self, forKey: .attributes)
        self.assetCryptos = try! values.decode([AssetCryptoDTO].self, forKey: .assetCryptos)
        self.assetFiats = try! values.decode([AssetFiatDTO].self, forKey: .assetFiats)
        self.assetCommodities = try! values.decode([AssetCommodityDTO].self, forKey: .assetCommodities)
    }
}
