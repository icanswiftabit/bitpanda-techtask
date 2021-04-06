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
    
    func getAssetsFiat() -> AnyPublisher<[AssetFiatDTO], Error> {
        Just(source.assetFiat).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func getAssetsCrypto() -> AnyPublisher<[AssetCryptoDTO], Error> {
        Just(source.assetCrypto).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func getAssetsCommodities() -> AnyPublisher<[AssetCommoditiesDTO], Error> {
        Just(source.assetCommodities).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
