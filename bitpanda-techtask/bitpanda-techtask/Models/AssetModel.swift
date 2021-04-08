//
//  AssetModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import Combine

final class AssetModel {
    enum SelectedAssetType: Int, CaseIterable {
        case cryptos, commodities, fiats
    }
    
    var currentTitle: CurrentValueSubject<String, Never> = CurrentValueSubject("All")
    var fiats: CurrentValueSubject<[AssetViewModel], Never> = CurrentValueSubject([AssetViewModel]())
    var cryptos: CurrentValueSubject<[AssetViewModel], Never> = CurrentValueSubject([AssetViewModel]())
    var commodities: CurrentValueSubject<[AssetViewModel], Never> = CurrentValueSubject([AssetViewModel]())
    var selectedSegment: CurrentValueSubject<SelectedAssetType, Never> = CurrentValueSubject(.cryptos)
    
    var currentlySelectedCountOfAssets: Int {
        switch selectedSegment.value {
        case .cryptos: return cryptos.value.count - 1
        case .commodities: return commodities.value.count - 1
        case .fiats: return fiats.value.count - 1
        }
    }
}
