//
//  ViewController.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import UIKit
import Combine

struct AssetModel {
    var currentTitle: CurrentValueSubject<String, Never> = CurrentValueSubject("All")
    var fiats: CurrentValueSubject<[AssetFiatDTO], Never> = CurrentValueSubject([AssetFiatDTO]())
    var crypto: CurrentValueSubject<[AssetCryptoDTO], Never> = CurrentValueSubject([AssetCryptoDTO]())
    var commodities: CurrentValueSubject<[AssetCommoditiesDTO], Never> = CurrentValueSubject([AssetCommoditiesDTO]())
}

final class AssetViewController<S>: UIViewController where S: Scheduler {
    private let assetView: AssetView = AssetView()
    private let repository: AssetRepositoryProtocol
    private let assertModel: AssetModel = AssetModel()
    private let scheduler: S
    private var bag = Set<AnyCancellable>()
    
    init(repository: AssetRepositoryProtocol, on scheduler: S) {
        self.repository = repository
        self.scheduler = scheduler
        super.init(nibName: nil, bundle: nil)
        
        setUpBindings()
        tabBarItem = UITabBarItem(title: "Asset", image: UIImage(systemName: "bitcoinsign.circle"), selectedImage: UIImage(systemName: "bitcoinsign.circle.fill"))
        
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
        assertModel.currentTitle
            .sink { [weak self] newTitle in
                self?.title = newTitle
            }
            .store(in: &bag)
    }
    
    func initialFetch() {
        repository.getAssetsFiat()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetFiatDTO], Never> in Empty<[AssetFiatDTO], Never>(completeImmediately: true) }
            .assign(to: \.value, on: assertModel.fiats)
            .store(in: &bag)
        
        repository.getAssetsCrypto().print()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetCryptoDTO], Never> in Empty<[AssetCryptoDTO], Never>(completeImmediately: true) }
            .assign(to: \.value, on: assertModel.crypto)
            .store(in: &bag)
        
        repository.getAssetsCommodities().print()
            .receive(on: scheduler)
            .catch { _ -> Empty<[AssetCommoditiesDTO], Never> in Empty<[AssetCommoditiesDTO], Never>(completeImmediately: true) }
            .assign(to: \.value, on: assertModel.commodities)
            .store(in: &bag)
    }
}

