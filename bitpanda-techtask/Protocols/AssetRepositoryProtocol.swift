//
//  AssetsRepositoryProtocol.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Combine

protocol AssetRepositoryProtocol {
    func getFiatAssets() -> AnyPublisher<[AssetFiatDTO], Error>
    func getCryptoAssets() -> AnyPublisher<[AssetCryptoDTO], Error>
    func getCommodityAssets() -> AnyPublisher<[AssetCommodityDTO], Error>
}

struct EmptyAssetRepository: AssetRepositoryProtocol {
    func getFiatAssets() -> AnyPublisher<[AssetFiatDTO], Error> {
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func getCryptoAssets() -> AnyPublisher<[AssetCryptoDTO], Error> {
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func getCommodityAssets() -> AnyPublisher<[AssetCommodityDTO], Error> {
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
