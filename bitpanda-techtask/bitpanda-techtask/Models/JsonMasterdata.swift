//
//  JsonMasterdata.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Foundation

struct JsonMasterdata: Decodable {
    let assetCrypto: [AssetCryptoDTO]
    let assetFiat: [AssetFiatDTO]
    let assetCommodities: [AssetCommoditiesDTO]
    
    enum DataKeys: String, CodingKey {
        case data
    }
    
    enum AttributesKeys: String, CodingKey {
        case attributes
    }
    
    enum AssetKeys: String, CodingKey {
        case assetCrypto = "cryptocoins"
        case assetFiat = "fiats"
        case assetCommodities = "commodities"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKeys.self)
        let attributes = try container.nestedContainer(keyedBy: AttributesKeys.self, forKey: .data)
        let values = try attributes.nestedContainer(keyedBy: AssetKeys.self, forKey: .attributes)
        self.assetCrypto = try! values.decode([AssetCryptoDTO].self, forKey: .assetCrypto)
        self.assetFiat = try! values.decode([AssetFiatDTO].self, forKey: .assetFiat)
        self.assetCommodities = try! values.decode([AssetCommoditiesDTO].self, forKey: .assetCommodities)
    }
}
