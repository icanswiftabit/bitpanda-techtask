//
//  WalletsModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Combine

final class WalletsModel {
    enum WalletType: Int, CaseIterable, CustomStringConvertible {
        case all, wallets, commodities, fiats
        
        var description: String {
            switch self {
            case .all: return "All"
            case .wallets: return "Wallets"
            case .commodities: return "Commodities"
            case .fiats: return "Fiats"
            }
        }
    }
    
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
    
    @Published private(set) var currentTitle = WalletType.all.description
    var wallets: CurrentValueSubject<[WalletViewModel], Never> = CurrentValueSubject([WalletViewModel]())
    var commodities: CurrentValueSubject<[WalletViewModel], Never> = CurrentValueSubject([WalletViewModel]())
    var fiats: CurrentValueSubject<[WalletFiatViewModel], Never> = CurrentValueSubject([WalletFiatViewModel]())
    var selectedSegment: CurrentValueSubject<WalletType, Never> = CurrentValueSubject(.all)
    var selectedSort: SortingOrder = .descendingByBalance
    var showDeletedWallets: Bool = false
    
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
    
    init() {
        setUpBindings()
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
