//
//  AssetsModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import Combine

final class AssetsModel {
    enum AssetType: Int, CaseIterable, CustomStringConvertible {
        case cryptos, commodities, fiats
        
        var description: String {
            switch self {
            case .cryptos: return "Cryptos"
            case .commodities: return "Commodities"
            case .fiats: return "Fiats"
            }
        }
    }
    
    @Published private(set) var currentTitle = AssetType.cryptos.description
    var fiats: CurrentValueSubject<[AssetFiatViewModel], Never> = CurrentValueSubject([AssetFiatViewModel]())
    var cryptos: CurrentValueSubject<[AssetViewModel], Never> = CurrentValueSubject([AssetViewModel]())
    var commodities: CurrentValueSubject<[AssetViewModel], Never> = CurrentValueSubject([AssetViewModel]())
    var selectedSegment: CurrentValueSubject<AssetType, Never> = CurrentValueSubject(.cryptos)
    
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        setUpBindings()
    }
    
    var currentlySelectedAssets: [AssetViewModelProtocol] {
        switch selectedSegment.value {
        case .cryptos: return cryptos.value
        case .commodities: return commodities.value
        case .fiats: return fiats.value.filter(hasWallets)
        }
    }
}

private extension AssetsModel {
    func setUpBindings() {
        selectedSegment.sink { [weak self] type in
            self?.currentTitle = type.description
        }
        .store(in: &bag)
    }
    
    func hasWallets(_ fiat: AssetFiatViewModel) -> Bool {
        fiat.hasWallets
    }
}
