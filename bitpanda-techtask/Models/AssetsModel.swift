//
//  AssetsModel.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import Combine

final class AssetsModel<S: Scheduler> {    
    @Published private(set) var currentTitle = AssetType.cryptos.description
    var fiats: CurrentValueSubject<[AssetFiatViewModel], Never> = CurrentValueSubject([AssetFiatViewModel]())
    var cryptos: CurrentValueSubject<[AssetViewModel], Never> = CurrentValueSubject([AssetViewModel]())
    var commodities: CurrentValueSubject<[AssetViewModel], Never> = CurrentValueSubject([AssetViewModel]())
    var selectedSegment: CurrentValueSubject<AssetType, Never> = CurrentValueSubject(.cryptos)
    
    private let repository: AssetRepositoryProtocol
    private let scheduler: S
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(repository: AssetRepositoryProtocol, on scheduler: S) {
        self.repository = repository
        self.scheduler = scheduler
        setUpBindings()
    }
    
    var currentlySelectedAssets: [AssetViewModelProtocol] {
        switch selectedSegment.value {
        case .cryptos: return cryptos.value
        case .commodities: return commodities.value
        case .fiats: return fiats.value.filter(hasWallets)
        }
    }
    
    func initialFetch() {
        repository.getFiatAssets()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetFiatDTO], Never> in Empty<[AssetFiatDTO], Never>(completeImmediately: true) }
            .map { dtos -> [AssetFiatViewModel] in dtos.map { AssetFiatViewModel(fiat: $0)} }
            .sink { [weak self] fiats in self?.fiats.send(fiats) }
            .store(in: &bag)
        
        repository.getCryptoAssets()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetCryptoDTO], Never> in Empty<[AssetCryptoDTO], Never>(completeImmediately: true) }
            .map { dtos -> [AssetViewModel] in dtos.map { AssetViewModel(crypto: $0)} }
            .sink { [weak self] cryptos in self?.cryptos.send(cryptos) }
            .store(in: &bag)
        
        repository.getCommodityAssets()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetCommodityDTO], Never> in Empty<[AssetCommodityDTO], Never>(completeImmediately: true) }
            .map { dtos -> [AssetViewModel] in dtos.map { AssetViewModel(commodity: $0)} }
            .sink { [weak self] commodities in self?.commodities.send(commodities) }
            .store(in: &bag)
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
