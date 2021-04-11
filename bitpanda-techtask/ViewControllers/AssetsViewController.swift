//
//  ViewController.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import UIKit
import Combine

final class AssetsViewController<S>: UIViewController where S: Scheduler {
    private let assetsView: AssetsView = AssetsView()
    private let repository: AssetRepositoryProtocol
    private let assetsModel: AssetsModel = AssetsModel()
    private let assetsTableDataSource: AssetsTableDataSource
    private let scheduler: S
    private var bag = Set<AnyCancellable>()
    
    init(repository: AssetRepositoryProtocol, on scheduler: S) {
        self.repository = repository
        self.scheduler = scheduler
        self.assetsTableDataSource = AssetsTableDataSource(assetsModel: self.assetsModel)
        super.init(nibName: nil, bundle: nil)
        
        setUpBindings()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(showSegmentControl))
        tabBarItem = UITabBarItem(title: "Asset", image: UIImage(systemName: "bitcoinsign.circle"), selectedImage: UIImage(systemName: "bitcoinsign.circle.fill"))
        assetsView.dataSoruce = assetsTableDataSource
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = assetsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        initialFetch()
    }
    
    @objc private func showSegmentControl() {
        assetsView.showSegmentControl.send(!assetsView.showSegmentControl.value)
        let buttonImage = assetsView.showSegmentControl.value ? UIImage(systemName: "line.horizontal.3.decrease.circle.fill") : UIImage(systemName: "line.horizontal.3.decrease.circle")
        navigationItem.rightBarButtonItem?.image = buttonImage
    }
}

private extension AssetsViewController {
    func setUpBindings() {
        assetsView.$selectedSegment
            .assign(to: \.value, on: assetsModel.selectedSegment)
            .store(in: &bag)
        
        assetsModel.selectedSegment.combineLatest(assetsModel.cryptos)
            .filter { $0.0 == .cryptos }
            .sink { _ in self.assetsView.reloadData.send() }
            .store(in: &bag)
        
        assetsModel.selectedSegment.combineLatest(assetsModel.commodities)
            .filter { $0.0 == .commodities }
            .sink { _ in self.assetsView.reloadData.send() }
            .store(in: &bag)
        
        assetsModel.selectedSegment.combineLatest(assetsModel.fiats)
            .filter { $0.0 == .fiats }
            .sink { _ in self.assetsView.reloadData.send() }
            .store(in: &bag)
        
        assetsModel.$currentTitle.sink { [weak self] title in
            self?.title = title
            self?.tabBarItem = UITabBarItem(title: "Asset", image: UIImage(systemName: "bitcoinsign.circle"), selectedImage: UIImage(systemName: "bitcoinsign.circle.fill"))
        }
        .store(in: &bag)
    }
    
    func initialFetch() {
        repository.getFiatAssets()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetFiatDTO], Never> in Empty<[AssetFiatDTO], Never>(completeImmediately: true) }
            .map { dtos -> [AssetFiatViewModel] in dtos.map { AssetFiatViewModel(fiat: $0)} }
            .sink { [weak self] fiats in self?.assetsModel.fiats.send(fiats) }
            .store(in: &bag)
        
        repository.getCryptoAssets()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetCryptoDTO], Never> in Empty<[AssetCryptoDTO], Never>(completeImmediately: true) }
            .map { dtos -> [AssetViewModel] in dtos.map { AssetViewModel(crypto: $0)} }
            .sink { [weak self] cryptos in self?.assetsModel.cryptos.send(cryptos) }
            .store(in: &bag)
        
        repository.getCommodityAssets()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetCommodityDTO], Never> in Empty<[AssetCommodityDTO], Never>(completeImmediately: true) }
            .map { dtos -> [AssetViewModel] in dtos.map { AssetViewModel(commodity: $0)} }
            .sink { [weak self] commodities in self?.assetsModel.commodities.send(commodities) }
            .store(in: &bag)
    }
}
