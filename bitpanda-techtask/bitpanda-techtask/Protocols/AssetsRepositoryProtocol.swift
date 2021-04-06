//
//  AssetsRepositoryProtocol.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Foundation

protocol AssetsRepositoryProtocol {
    func getAssetsFiat() -> [AssetFiatDTO]
    func getAssetsCrypto() -> [AssetCryptoDTO]
    func getAssetsCommodities() -> [AssetCommoditiesDTO]
}
