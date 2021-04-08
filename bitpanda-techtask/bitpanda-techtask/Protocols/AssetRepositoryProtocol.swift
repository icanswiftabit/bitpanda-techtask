//
//  AssetsRepositoryProtocol.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Combine

protocol AssetRepositoryProtocol {
    func getAssetsFiats() -> AnyPublisher<[AssetFiatDTO], Error>
    func getAssetsCryptos() -> AnyPublisher<[AssetCryptoDTO], Error>
    func getAssetsCommodities() -> AnyPublisher<[AssetCommodityDTO], Error>
}
