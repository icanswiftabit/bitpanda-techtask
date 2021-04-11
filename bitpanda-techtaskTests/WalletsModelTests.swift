//
//  WalletsModelTests.swift
//  bitpanda-techtaskTests
//
//  Created by Blazej Wdowikowski on 11/04/2021.
//

import XCTest
@testable import bitpanda_techtask
import Combine

final class WalletsModelTests: XCTestCase {
    
    struct WalletRepositoryMock: WalletRepositoryProtocol {
        func getWallets() -> AnyPublisher<([WalletDTO], [AssetCryptoDTO]), Error> {
            Empty<([WalletDTO], [AssetCryptoDTO]), Error>(completeImmediately: true).eraseToAnyPublisher()
        }
        
        func getFiatWallets() -> AnyPublisher<([WalletFiatDTO], [AssetFiatDTO]), Error> {
            Empty<([WalletFiatDTO], [AssetFiatDTO]), Error>(completeImmediately: true).eraseToAnyPublisher()
        }
        
        func getCommodityWallets() -> AnyPublisher<([WalletCommodityDTO], [AssetCommodityDTO]), Error> {
            Empty<([WalletCommodityDTO], [AssetCommodityDTO]), Error>(completeImmediately: true).eraseToAnyPublisher()
        }
        
        
    }
    
    func test_hasCorrectValues() {
        // Arrange
        let sut = WalletsModel(repository: WalletRepositoryMock(), on: ImmediateScheduler.shared)
        let wallets = (0...10).map { WalletViewModel.sample(id: "\($0)", deleted: $0 % 2 == 0, isDefault: $0 % 3 == 0) }
        let commodities = (0...9).map { WalletViewModel.sample(id: "\($0)", deleted: $0 % 2 == 0, isDefault: $0 % 3 == 0) }
        let fiats = (0...8).map { WalletFiatViewModel.sample(id: "\($0)") }
        let expectedCurrentlySelectedWallets: [WalletViewModelProtocol] = [
            wallets.filter { !$0.deleted } as [WalletViewModelProtocol],
            fiats as [WalletViewModelProtocol],
            commodities.filter { !$0.deleted } as [WalletViewModelProtocol]
        ]
        .flatMap { $0 }
        .sorted { Double($0.balance)! > Double($1.balance)!  }

        // Act
        _ = Just(wallets)
            .sink { sut.wallets.send($0) }
        _ = Just(commodities)
            .sink { sut.commodities.send($0) }
        _ = Just(fiats)
            .sink { sut.fiats.send($0) }
        
        // Assert
        
        XCTAssert(sut.wallets.value == wallets)
        XCTAssert(sut.commodities.value == commodities)
        XCTAssert(sut.fiats.value == fiats)
        XCTAssert(sut.selectedSegment.value == .all)
        assetEqual(sut.currentlySelectedWallets, expectedCurrentlySelectedWallets)
    }
    
    func test_currentlySelectedWallets_forSelectedSegment() {
        // Arrange
        let sut = WalletsModel(repository: WalletRepositoryMock(), on: ImmediateScheduler.shared)
        let wallets = (0...10).map { WalletViewModel.sample(id: "\($0)", deleted: $0 % 2 == 0, isDefault: $0 % 3 == 0) }
        let commodities = (0...9).map { WalletViewModel.sample(id: "\($0)", deleted: $0 % 2 == 0, isDefault: $0 % 3 == 0) }
        let fiats = (0...8).map { WalletFiatViewModel.sample(id: "\($0)") }
        let expectedAll: [WalletViewModelProtocol] = [
            wallets.filter { !$0.deleted } as [WalletViewModelProtocol],
            fiats as [WalletViewModelProtocol],
            commodities.filter { !$0.deleted } as [WalletViewModelProtocol]
        ]
        .flatMap { $0 }
        .sorted { Double($0.balance)! > Double($1.balance)!  }

        _ = Just(wallets)
            .sink { sut.wallets.send($0) }
        _ = Just(commodities)
            .sink { sut.commodities.send($0) }
        _ = Just(fiats)
            .sink { sut.fiats.send($0) }
        
        // Act
        sut.selectedSegment.send(.commodities)
        
        // Assert
        assetEqual(sut.currentlySelectedWallets, commodities.filter { !$0.deleted }.reversed())

        // Act
        sut.selectedSegment.send(.fiats)
        
        // Assert
        assetEqual(sut.currentlySelectedWallets, fiats.reversed())
        
        // Act
        sut.selectedSegment.send(.wallets)
        
        // Assert
        assetEqual(sut.currentlySelectedWallets, wallets.filter { !$0.deleted }.reversed())
        
        // Act
        sut.selectedSegment.send(.all)
        
        // Assert
        assetEqual(sut.currentlySelectedWallets, expectedAll)
    }
    
    func test_currentlySelectedWallets_forNotDeletedWallets() {
        // Arrange
        let sut = WalletsModel(repository: WalletRepositoryMock(), on: ImmediateScheduler.shared)
        let wallets = (0...10).map { WalletViewModel.sample(id: "\($0)", deleted: $0 % 2 == 0, isDefault: $0 % 3 == 0) }
        let commodities = (0...9).map { WalletViewModel.sample(id: "\($0)", deleted: $0 % 2 == 0, isDefault: $0 % 3 == 0) }
        let fiats = (0...8).map { WalletFiatViewModel.sample(id: "\($0)") }
        
        let expectedAllWallets: [WalletViewModelProtocol] = [
            wallets as [WalletViewModelProtocol],
            fiats as [WalletViewModelProtocol],
            commodities as [WalletViewModelProtocol]
        ]
        .flatMap { $0 }
        .sorted { Double($0.balance)! > Double($1.balance)!  }
        
        let expectedOnlyNotDeletedWallets: [WalletViewModelProtocol] = [
            wallets.filter { !$0.deleted } as [WalletViewModelProtocol],
            fiats as [WalletViewModelProtocol],
            commodities.filter { !$0.deleted } as [WalletViewModelProtocol]
        ]
        .flatMap { $0 }
        .sorted { Double($0.balance)! > Double($1.balance)!  }

        _ = Just(wallets)
            .sink { sut.wallets.send($0) }
        _ = Just(commodities)
            .sink { sut.commodities.send($0) }
        _ = Just(fiats)
            .sink { sut.fiats.send($0) }
        
        // Act
        sut.showDeletedWallets = true
        
        // Assert
        assetEqual(sut.currentlySelectedWallets, expectedAllWallets)
        
        // Act
        sut.showDeletedWallets = false
        
        // Assert
        assetEqual(sut.currentlySelectedWallets, expectedOnlyNotDeletedWallets)
    }
    
    private func assetEqual(_ sut: [WalletViewModelProtocol], _ expect: [WalletViewModelProtocol]) {
        zip(sut, expect).forEach{ (sutViewModel, expectedViewModel) in
            if let sutWalletViewModel = sutViewModel as? WalletViewModel,
               let expectedWalletViewModel = expectedViewModel as? WalletViewModel {
                XCTAssert(sutWalletViewModel == expectedWalletViewModel)
            } else if let sutFiatWalletViewModel = sutViewModel as? WalletFiatViewModel,
                      let expectedFiatWalletViewModel = expectedViewModel as? WalletFiatViewModel {
                XCTAssert(sutFiatWalletViewModel == expectedFiatWalletViewModel)
            } else {
                XCTFail("currentlySelectedWallet contains unknown view model")
            }
        }
    }
}

extension WalletFiatViewModel {
    static func sample(id: String) -> WalletFiatViewModel {
        WalletFiatViewModel(
            fiat: WalletFiatDTO(
                id: id,
                attributes: WalletFiatDTO.Attributes(
                    name: "\(id).name",
                    fiatSymbol: "\(id).fiatSymbol",
                    balance: "\(id).\(id)"
                )
            ),
            logoAsset: ImageAssetResource(
                lightUrl: URL(string: "https://\(id).light"), darkUrl: URL(string: "https://\(id).dark")
            )
        )
    }
}

private extension WalletViewModel {
    static func sample(id: String, deleted: Bool, isDefault: Bool) -> WalletViewModel {
        WalletViewModel(
            commodity: WalletCommodityDTO(
                id: id,
                attributes: WalletCommodityDTO.Attributes(
                    name: "\(id).name",
                    cryptocoinSymbol: "\(id).cryptocoinSymbol",
                    balance: "\(id).\(id)",
                    deleted: deleted,
                    isDefault: isDefault
                )
            ),
            logoAsset: ImageAssetResource(
                lightUrl: URL(string: "https://\(id).light"), darkUrl: URL(string: "https://\(id).dark")
            )
        )
    }
}
