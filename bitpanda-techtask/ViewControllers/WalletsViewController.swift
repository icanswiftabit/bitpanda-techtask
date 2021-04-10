//
//  WalletsViewController.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import UIKit
import Combine

final class WalletsViewController<S>: UIViewController where S: Scheduler {
    private let walletsView: WalletsView = WalletsView()
    private let repository: WalletRepositoryProtocol
    private let walletsModel: WalletsModel = WalletsModel()
    private let walletsTableDataSource: WalletsTableDataSource
    private let scheduler: S
    private var bag = Set<AnyCancellable>()
    
    init(repository: WalletRepositoryProtocol, on scheduler: S) {
        self.repository = repository
        self.scheduler = scheduler
        self.walletsTableDataSource = WalletsTableDataSource(walletsModel: walletsModel)
        super.init(nibName: nil, bundle: nil)
        
        setUpBindings()
        tabBarItem = UITabBarItem(title: "Wallets", image: UIImage(systemName: "creditcard.circle"), selectedImage: UIImage(systemName: "creditcard.circle.fill"))
        walletsView.dataSoruce = walletsTableDataSource
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = walletsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        initialFetch()
    }
}

private extension WalletsViewController {
    func setUpBindings() {
        walletsView.$selectedSegment
            .assign(to: \.value, on: walletsModel.selectedSegment)
            .store(in: &bag)
        
        
        let wallets = walletsModel.wallets.combineLatest(walletsModel.commodities, walletsModel.fiats)
        walletsModel.selectedSegment.combineLatest(wallets)
            .filter { $0.0 == .all }
            .sink { _ in self.walletsView.reloadData.send() }
            .store(in: &bag)
        
        walletsModel.selectedSegment.combineLatest(walletsModel.wallets)
            .filter { $0.0 == .wallets }
            .sink { _ in self.walletsView.reloadData.send() }
            .store(in: &bag)

        walletsModel.selectedSegment.combineLatest(walletsModel.commodities)
            .filter { $0.0 == .commodities }
            .sink { _ in self.walletsView.reloadData.send() }
            .store(in: &bag)

        walletsModel.selectedSegment.combineLatest(walletsModel.fiats)
            .filter { $0.0 == .fiats }
            .sink { _ in self.walletsView.reloadData.send() }
            .store(in: &bag)
        
        walletsModel.$currentTitle.sink { [weak self] title in
            self?.title = title
        }
        .store(in: &bag)
    }
    
    func initialFetch() {
        repository.getWallets()
            .receive(on: scheduler)
            .catch { _ -> Empty<[WalletDTO], Never> in Empty<[WalletDTO], Never>(completeImmediately: true) }
            .map { dtos -> [WalletViewModel] in dtos.map { WalletViewModel(wallet: $0)} }
            .sink { [weak self] wallets in self?.walletsModel.wallets.send(wallets) }
            .store(in: &bag)
        
        repository.getCommodityWallets()
            .receive(on: scheduler)
            .catch { _ -> Empty<[WalletCommodityDTO], Never> in Empty<[WalletCommodityDTO], Never>(completeImmediately: true) }
            .map { dtos -> [WalletViewModel] in dtos.map { WalletViewModel(commodity: $0)} }
            .sink { [weak self] commodities in self?.walletsModel.commodities.send(commodities) }
            .store(in: &bag)

        repository.getFiatWallets()
            .receive(on: scheduler)
            .catch { _ -> Empty<[WalletFiatDTO], Never> in Empty<[WalletFiatDTO], Never>(completeImmediately: true) }
            .map { dtos -> [WalletFiatViewModel] in dtos.map { WalletFiatViewModel(fiat: $0)} }
            .sink { [weak self] fiats in self?.walletsModel.fiats.send(fiats) }
            .store(in: &bag)
    }
}
