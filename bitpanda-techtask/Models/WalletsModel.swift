//
//  WalletsModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Foundation
import Combine

final class WalletsModel<S: Scheduler> {
    @Published private(set) var currentTitle = WalletType.all.description
    var wallets: CurrentValueSubject<[WalletViewModel], Never> = CurrentValueSubject([WalletViewModel]())
    var commodities: CurrentValueSubject<[WalletViewModel], Never> = CurrentValueSubject([WalletViewModel]())
    var fiats: CurrentValueSubject<[WalletFiatViewModel], Never> = CurrentValueSubject([WalletFiatViewModel]())
    var selectedSegment: CurrentValueSubject<WalletType, Never> = CurrentValueSubject(.all)
    var selectedSort: SortingOrder = .descendingByBalance
    var showDeletedWallets: Bool = false
    private let repository: WalletRepositoryProtocol
    private let scheduler: S
    
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var currentlySelectedWallets: [WalletViewModelProtocol] {
        let walletsForReturn: [WalletViewModelProtocol] = { () -> [WalletViewModelProtocol] in
            switch selectedSegment.value {
            case .all:
                return [
                    walletsForCurrentlySelectedWallets as [WalletViewModelProtocol],
                    fiats.value as [WalletViewModelProtocol],
                    commoditiesForCurrentlySelectedWallets as [WalletViewModelProtocol]
                ]
                .flatMap { $0 }
                
            case .commodities: return commoditiesForCurrentlySelectedWallets
            case .fiats: return fiats.value
            case .wallets: return walletsForCurrentlySelectedWallets
            }
        }()
        return walletsForReturn.sorted(by: selectedSort.sort)
    }
    
    init(repository: WalletRepositoryProtocol, on scheduler: S) {
        self.scheduler = scheduler
        self.repository = repository
        setUpBindings()
    }
    
    func initialFetch() {
        repository.getWallets()
            .receive(on: scheduler)
            .catch { _ -> Empty<([WalletDTO], [AssetCryptoDTO]), Never> in Empty<([WalletDTO], [AssetCryptoDTO]), Never>(completeImmediately: true) }
            .map { dtos -> [WalletViewModel] in
                dtos.0.map { walletDto in
                    let firstAssetDto = dtos.1.first { assetDto in assetDto.attributes.symbol == walletDto.attributes.cryptocoinSymbol }
                    let logoLightUrl = URL(string: firstAssetDto?.attributes.logo)
                    let logoDarkUrl = URL(string: firstAssetDto?.attributes.logoDark)
                    
                    return WalletViewModel(wallet: walletDto, logoAsset: ImageAssetResource(lightUrl: logoLightUrl, darkUrl: logoDarkUrl))
                }
            }
            .sink { [weak self] wallets in self?.wallets.send(wallets) }
            .store(in: &bag)
        
        repository.getCommodityWallets()
            .receive(on: scheduler)
            .catch { _ -> Empty<([WalletCommodityDTO], [AssetCommodityDTO]), Never> in Empty<([WalletCommodityDTO], [AssetCommodityDTO]), Never>(completeImmediately: true) }
            .map { dtos -> [WalletViewModel] in
                dtos.0.map { commodityDto in
                    let firstAssetDto = dtos.1.first { assetDto in assetDto.attributes.symbol == commodityDto.attributes.cryptocoinSymbol }
                    let logoLightUrl = URL(string: firstAssetDto?.attributes.logo)
                    let logoDarkUrl = URL(string: firstAssetDto?.attributes.logoDark)
                    
                    return WalletViewModel(commodity: commodityDto, logoAsset: ImageAssetResource(lightUrl: logoLightUrl, darkUrl: logoDarkUrl))
                }
            }
            .sink { [weak self] commodities in self?.commodities.send(commodities) }
            .store(in: &bag)

        repository.getFiatWallets()
            .receive(on: scheduler)
            .catch { _ -> Empty<([WalletFiatDTO], [AssetFiatDTO]), Never> in Empty<([WalletFiatDTO], [AssetFiatDTO]), Never>(completeImmediately: true) }
            .map { dtos -> [WalletFiatViewModel] in
                dtos.0.map { fiatDto in
                    let firstAssetDto = dtos.1.first { assetDto in assetDto.attributes.symbol == fiatDto.attributes.fiatSymbol }
                    let logoLightUrl = URL(string: firstAssetDto?.attributes.logo)
                    let logoDarkUrl = URL(string: firstAssetDto?.attributes.logoDark)
                    
                    return WalletFiatViewModel(fiat: fiatDto, logoAsset: ImageAssetResource(lightUrl: logoLightUrl, darkUrl: logoDarkUrl))
                }
            }
            .sink { [weak self] fiats in self?.fiats.send(fiats) }
            .store(in: &bag)
    }
}

extension WalletsModel {
    enum SortingOrder {
        case descendingByBalance
        
        var sort: ((WalletViewModelProtocol, WalletViewModelProtocol) -> Bool) {
            switch self {
            case .descendingByBalance:
                return {
                    guard let first = Double($0.balance), let second = Double($1.balance) else { return false }
                    return first > second
                }
            }
        }
    }
}

private extension WalletsModel {
    func setUpBindings() {
        selectedSegment.sink { [weak self] type in
            self?.currentTitle = type.description
        }
        .store(in: &bag)
    }
    
    private var commoditiesForCurrentlySelectedWallets: [WalletViewModel] {
        if !showDeletedWallets {
            return commodities.value.filter { !$0.deleted }
        }
        return commodities.value
    }
    
    private var walletsForCurrentlySelectedWallets: [WalletViewModel] {
        if !showDeletedWallets {
            return wallets.value.filter { !$0.deleted }
        }
        return wallets.value
    }
}

private extension URL {
    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(string: string)
    }
}
