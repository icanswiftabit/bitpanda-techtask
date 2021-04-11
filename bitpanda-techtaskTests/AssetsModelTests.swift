//
//  AssetsModelTests.swift
//  bitpanda-techtaskTests
//
//  Created by Blazej Wdowikowski on 09/04/2021.
//

import XCTest
@testable import bitpanda_techtask
import Combine

final class AssetsModelTests: XCTestCase {
    
    func test_hasCorrectValues() {
        
        // Arrange
        let sut = AssetsModel()
        let fiats = (0...10).map { AssetFiatViewModel.sample(id: "\($0)", hasWallets: $0 % 2 == 0) }
        let cryptos = (0...9).map { AssetViewModel.sample(id: "\($0)") }
        let commodities = (0...8).map { AssetViewModel.sample(id: "\($0)") }
        
        // Act
        _ = Just(fiats)
            .sink { sut.fiats.send($0) }
        _ = Just(cryptos)
            .sink { sut.cryptos.send($0) }
        _ = Just(commodities)
            .sink { sut.commodities.send($0) }
            
        // Assert
        XCTAssert(sut.fiats.value == fiats)
        XCTAssert(sut.cryptos.value == cryptos)
        XCTAssert(sut.commodities.value == commodities)
        XCTAssert(sut.selectedSegment.value == .cryptos)
        XCTAssert((sut.currentlySelectedAssets as! [AssetViewModel]) == cryptos)
    }
    
    func test_hasCorrectValues_forSelectedSegment() {
        // Arrange
        let sut = AssetsModel()
        let fiats = (0...10).map { AssetFiatViewModel.sample(id: "\($0)", hasWallets: $0 % 2 == 0) }
        let fiatsWithWallets = fiats.filter { $0.hasWallets }
        let cryptos = (0...9).map { AssetViewModel.sample(id: "\($0)") }
        let commodities = (0...8).map { AssetViewModel.sample(id: "\($0)") }
        
        _ = Just(fiats)
            .sink { sut.fiats.send($0) }
        _ = Just(cryptos)
            .sink { sut.cryptos.send($0) }
        _ = Just(commodities)
            .sink { sut.commodities.send($0) }
        
        // Act
        _ = Just(AssetsModel.AssetType.fiats)
            .assign(to: \.value, on: sut.selectedSegment)
            
        // Assert
        XCTAssert(sut.selectedSegment.value == .fiats)
        XCTAssert((sut.currentlySelectedAssets as! [AssetFiatViewModel]) == fiatsWithWallets)
        
        // Act
        _ = Just(AssetsModel.AssetType.commodities)
            .assign(to: \.value, on: sut.selectedSegment)
            
        // Assert
        XCTAssert(sut.selectedSegment.value == .commodities)
        XCTAssert((sut.currentlySelectedAssets as! [AssetViewModel]) == commodities)
    }
}

private extension AssetFiatViewModel {
    static func sample(id: String, hasWallets: Bool) -> AssetFiatViewModel {
        AssetFiatViewModel(
            fiat: AssetFiatDTO(
                id: id,
                attributes: AssetFiatDTO.Attributes(
                    name: "\(id).name",
                    logo: "\(id).logo",
                    symbol: "\(id).symbol",
                    hasWallets: hasWallets
                )
            )
        )
    }
}

private extension AssetViewModel {
    static func sample(id: String) -> AssetViewModel {
        AssetViewModel(
            crypto: AssetCryptoDTO(
                id: id,
                attributes: AssetCryptoDTO.Attributes(
                    name: "\(id).name",
                    logo: "\(id).logo",
                    symbol: "\(id).symbol",
                    avgPrice: "\(id).\(id)",
                    precisionForFiatPrice: 2
                )
            )
        )
    }
}

