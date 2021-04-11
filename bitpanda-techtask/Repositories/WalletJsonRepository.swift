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
    
    func getWallets() -> AnyPublisher<([WalletDTO], [AssetCryptoDTO]), Error> {
        let wallets = Just(source.wallets).setFailureType(to: Error.self)
        let assets = Just(source.cryptoAssets).setFailureType(to: Error.self)
            
        return wallets.zip(assets).eraseToAnyPublisher()
    }
    
    func getFiatWallets() -> AnyPublisher<([WalletFiatDTO], [AssetFiatDTO]), Error> {
        let fiats = Just(source.fiatWallets).setFailureType(to: Error.self)
        let assets = Just(source.fiatAssets).setFailureType(to: Error.self)
            
        return fiats.zip(assets).eraseToAnyPublisher()
    }
    
    func getCommodityWallets() -> AnyPublisher<([WalletCommodityDTO], [AssetCommodityDTO]), Error> {
        let commodities = Just(source.commodityWallets).setFailureType(to: Error.self)
        let assets = Just(source.commodityAssets).setFailureType(to: Error.self)
        
        return commodities.zip(assets).eraseToAnyPublisher()
    }
}
