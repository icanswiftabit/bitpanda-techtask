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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(showSegmentControl))
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
    
    @objc private func showSegmentControl() {
        walletsView.showSegmentControl.send(!walletsView.showSegmentControl.value)
        let buttonImage = walletsView.showSegmentControl.value ? UIImage(systemName: "line.horizontal.3.decrease.circle.fill") : UIImage(systemName: "line.horizontal.3.decrease.circle")
        navigationItem.rightBarButtonItem?.image = buttonImage
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
            self?.tabBarItem = UITabBarItem(title: "Wallets", image: UIImage(systemName: "creditcard.circle"), selectedImage: UIImage(systemName: "creditcard.circle.fill"))
        }
        .store(in: &bag)
    }
    
    func initialFetch() {
        repository.getWallets()
            .receive(on: scheduler)
            .catch { _ -> Empty<([WalletDTO], [AssetCryptoDTO]), Never> in Empty<([WalletDTO], [AssetCryptoDTO]), Never>(completeImmediately: true) }
            .map { dtos -> [WalletViewModel] in
                dtos.0.map { walletDto in
                    let urlString = dtos.1.first { cryptoDto in cryptoDto.attributes.symbol == walletDto.attributes.cryptocoinSymbol }?.attributes.logo
                    let iconLightUrl = URL(string: urlString)
                    return WalletViewModel(wallet: walletDto, iconLightUrl: iconLightUrl)
                }
            }
            .sink { [weak self] wallets in self?.walletsModel.wallets.send(wallets) }
            .store(in: &bag)
        
        repository.getCommodityWallets()
            .receive(on: scheduler)
            .catch { _ -> Empty<([WalletCommodityDTO], [AssetCommodityDTO]), Never> in Empty<([WalletCommodityDTO], [AssetCommodityDTO]), Never>(completeImmediately: true) }
            .map { dtos -> [WalletViewModel] in
                dtos.0.map { commodityDto in
                    let urlString = dtos.1.first { cryptoDto in cryptoDto.attributes.symbol == commodityDto.attributes.cryptocoinSymbol }?.attributes.logo
                    let iconLightUrl = URL(string: urlString)
                    return WalletViewModel(commodity: commodityDto, iconLightUrl: iconLightUrl)
                }
            }
            .sink { [weak self] commodities in self?.walletsModel.commodities.send(commodities) }
            .store(in: &bag)

        repository.getFiatWallets()
            .receive(on: scheduler)
            .catch { _ -> Empty<([WalletFiatDTO], [AssetFiatDTO]), Never> in Empty<([WalletFiatDTO], [AssetFiatDTO]), Never>(completeImmediately: true) }
            .map { dtos -> [WalletFiatViewModel] in
                dtos.0.map { fiatDto in
                    let urlString = dtos.1.first { assetDto in assetDto.attributes.symbol == fiatDto.attributes.fiatSymbol }?.attributes.logo
                    let iconLightUrl = URL(string: urlString)
                    return WalletFiatViewModel(fiat: fiatDto, iconLightUrl: iconLightUrl)
                }
            }
            .sink { [weak self] fiats in self?.walletsModel.fiats.send(fiats) }
            .store(in: &bag)
    }
}

private extension URL {
    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(string: string)
    }
}
