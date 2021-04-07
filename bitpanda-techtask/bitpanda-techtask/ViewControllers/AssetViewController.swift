//
//  ViewController.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import UIKit
import Combine

final class AssetViewController<S>: UIViewController where S: Scheduler {
    private let assetView: AssetView = AssetView()
    private let repository: AssetRepositoryProtocol
    private let assetModel: AssetModel = AssetModel()
    private let assetTableDataSource: AssetTableDataSource
    private let scheduler: S
    private var bag = Set<AnyCancellable>()
    
    init(repository: AssetRepositoryProtocol, on scheduler: S) {
        self.repository = repository
        self.scheduler = scheduler
        self.assetTableDataSource = AssetTableDataSource(assetModel: self.assetModel)
        super.init(nibName: nil, bundle: nil)
        
        setUpBindings()
        tabBarItem = UITabBarItem(title: "Asset", image: UIImage(systemName: "bitcoinsign.circle"), selectedImage: UIImage(systemName: "bitcoinsign.circle.fill"))
        assetView.dataSoruce = assetTableDataSource
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = assetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        initialFetch()
    }
}

private extension AssetViewController {
    func setUpBindings() {
        assetView.selectedSegment
            .assign(to: \.value, on: assetModel.selectedSegment)
            .store(in: &bag)
        
        assetModel.selectedSegment.combineLatest(assetModel.crypto) { selectedSegment, crypto -> Bool in
            guard case .crypto = selectedSegment else { return false }
            return true
        }
        .sink(receiveValue: reloadTableView(ifNeeded:))
        .store(in: &bag)
        
        assetModel.selectedSegment.combineLatest(assetModel.commodities) { selectedSegment, crypto -> Bool in
            guard case .commodities = selectedSegment else { return false }
            return true
        }
        .sink(receiveValue: reloadTableView(ifNeeded:))
        .store(in: &bag)
        
        assetModel.selectedSegment.combineLatest(assetModel.fiats) { selectedSegment, crypto -> Bool in
            guard case .fiats = selectedSegment else { return false }
            return true
        }
        .sink(receiveValue: reloadTableView(ifNeeded:))
        .store(in: &bag)
    }
    
    func reloadTableView(ifNeeded: Bool) {
        guard ifNeeded else { return }
        assetView.reloadData.send()
    }
    
    func initialFetch() {
        repository.getAssetsFiat()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetFiatDTO], Never> in Empty<[AssetFiatDTO], Never>(completeImmediately: true) }
            .assign(to: \.value, on: assetModel.fiats)
            .store(in: &bag)
        
        repository.getAssetsCrypto().print()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetCryptoDTO], Never> in Empty<[AssetCryptoDTO], Never>(completeImmediately: true) }
            .assign(to: \.value, on: assetModel.crypto)
            .store(in: &bag)
        
        repository.getAssetsCommodities().print()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetCommoditiesDTO], Never> in Empty<[AssetCommoditiesDTO], Never>(completeImmediately: true) }
            .assign(to: \.value, on: assetModel.commodities)
            .store(in: &bag)
    }
}
