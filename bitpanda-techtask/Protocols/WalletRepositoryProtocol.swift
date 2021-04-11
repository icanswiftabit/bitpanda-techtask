//
//  WalletRepositoryProtocol.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Combine

protocol WalletRepositoryProtocol {
    func getWallets() -> AnyPublisher<([WalletDTO], [AssetCryptoDTO]), Error>
    func getFiatWallets() -> AnyPublisher<([WalletFiatDTO], [AssetFiatDTO]), Error>
    func getCommodityWallets() -> AnyPublisher<([WalletCommodityDTO], [AssetCommodityDTO]), Error>
}
