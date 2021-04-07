//
//  AssetModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import Combine

final class AssetModel {
    enum SelectedAssetType: Int, CaseIterable {
        case crypto, commodities, fiats
    }
    
    var currentTitle: CurrentValueSubject<String, Never> = CurrentValueSubject("All")
    var fiats: CurrentValueSubject<[AssetFiatDTO], Never> = CurrentValueSubject([AssetFiatDTO]())
    var crypto: CurrentValueSubject<[AssetCryptoDTO], Never> = CurrentValueSubject([AssetCryptoDTO]())
    var commodities: CurrentValueSubject<[AssetCommoditiesDTO], Never> = CurrentValueSubject([AssetCommoditiesDTO]())
    var selectedSegment: CurrentValueSubject<SelectedAssetType, Never> = CurrentValueSubject(.crypto)
    
    var currentlySelectedCountOfAssets: Int {
        switch selectedSegment.value {
        case .crypto: return crypto.value.count - 1
        case .commodities: return commodities.value.count - 1
        case .fiats: return fiats.value.count - 1
        }
    }
}
