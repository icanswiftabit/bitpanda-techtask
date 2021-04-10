//
//  WalletJsonRepository.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Foundation
import Combine

final class WalletJsonRepository: WalletRepositoryProtocol {
    let source: JsonMasterdata
    
    init?(jsonData: Data) {
        guard let source = try? JSONDecoder().decode(JsonMasterdata.self, from: jsonData) else { return nil }
        self.source = source
    }
    
    func getWallets() -> AnyPublisher<[WalletDTO], Error> {
        Just(source.wallets).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func getFiatWallets() -> AnyPublisher<[WalletFiatDTO], Error> {
        Just(source.fiatWallets).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func getCommodityWallets() -> AnyPublisher<[WalletCommodityDTO], Error> {
        Just(source.commodityWallets).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
