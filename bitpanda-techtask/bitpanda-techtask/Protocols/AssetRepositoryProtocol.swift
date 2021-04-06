//
//  AssetsRepositoryProtocol.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Combine

protocol AssetRepositoryProtocol {
    func getAssetsFiat() -> AnyPublisher<[AssetFiatDTO], Error>
    func getAssetsCrypto() -> AnyPublisher<[AssetCryptoDTO], Error>
    func getAssetsCommodities() -> AnyPublisher<[AssetCommoditiesDTO], Error>
}
