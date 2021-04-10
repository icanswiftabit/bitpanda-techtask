//
//  WalletsModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Combine

final class WalletsModel {
    enum SelectedWalletType: Int, CaseIterable, CustomStringConvertible {
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
    
    @Published private(set) var currentTitle = SelectedWalletType.all.description
    var wallets: CurrentValueSubject<[WalletViewModel], Never> = CurrentValueSubject([WalletViewModel]())
    var commodities: CurrentValueSubject<[WalletViewModel], Never> = CurrentValueSubject([WalletViewModel]())
    var fiats: CurrentValueSubject<[WalletFiatViewModel], Never> = CurrentValueSubject([WalletFiatViewModel]())
    var selectedSegment: CurrentValueSubject<SelectedWalletType, Never> = CurrentValueSubject(.all)
    
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()

    var currentlySelectedAssets: [WalletViewModelProtocol] {
        switch selectedSegment.value {
        case .all:
            return [
                wallets.value as [WalletViewModelProtocol],
                commodities.value as [WalletViewModelProtocol],
                fiats.value as [WalletViewModelProtocol]
            ]
            .flatMap { $0 }
                
        case .commodities: return commodities.value
        case .fiats: return fiats.value
        case .wallets: return wallets.value
        }
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
}
