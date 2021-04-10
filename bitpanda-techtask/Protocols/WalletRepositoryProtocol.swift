//
//  WalletRepositoryProtocol.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Combine

protocol WalletRepositoryProtocol {
    func getWallets() -> AnyPublisher<[WalletDTO], Error>
    func getFiatWallets() -> AnyPublisher<[WalletFiatDTO], Error>
    func getCommodityWallets() -> AnyPublisher<[WalletCommodityDTO], Error>
}
