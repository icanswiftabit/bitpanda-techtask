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
    
    func getAssetsFiats() -> AnyPublisher<[AssetFiatDTO], Error> {
        Just(source.assetFiats).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func getAssetsCryptos() -> AnyPublisher<[AssetCryptoDTO], Error> {
        Just(source.assetCryptos).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func getAssetsCommodities() -> AnyPublisher<[AssetCommodityDTO], Error> {
        Just(source.assetCommodities).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
