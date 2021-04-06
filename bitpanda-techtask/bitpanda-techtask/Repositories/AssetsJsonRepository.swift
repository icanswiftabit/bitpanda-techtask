//
//  AssetsJsonRepository.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Foundation

final class AssetsJsonRepository: AssetsRepositoryProtocol {
    let source: JsonMasterdata
    
    init?(jsonData: Data) {
        guard let source = try? JSONDecoder().decode(JsonMasterdata.self, from: jsonData) else { return nil }
        self.source = source
    }
    
    func getAssetsFiat() -> [AssetFiatDTO] {
        source.assetFiat
    }
    
    func getAssetsCrypto() -> [AssetCryptoDTO] {
        source.assetCrypto
    }
    
    func getAssetsCommodities() -> [AssetCommoditiesDTO] {
        source.assetCommodities
    }
}
