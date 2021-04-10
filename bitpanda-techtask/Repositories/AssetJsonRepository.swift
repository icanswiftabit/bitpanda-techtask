//
//  AssetsJsonRepository.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Foundation
import Combine

final class AssetJsonRepository: AssetRepositoryProtocol {
    let source: JsonMasterdata
    
    init?(jsonData: Data) {
        guard let source = try? JSONDecoder().decode(JsonMasterdata.self, from: jsonData) else { return nil }
        self.source = source
    }
    
    func getFiatAssets() -> AnyPublisher<[AssetFiatDTO], Error> {
        Just(source.fiatAssets).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func getCryptoAssets() -> AnyPublisher<[AssetCryptoDTO], Error> {
        Just(source.cryptoAssets).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func getCommodityAssets() -> AnyPublisher<[AssetCommodityDTO], Error> {
        Just(source.commodityAssets).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
