//
//  WalletsViewController.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import UIKit
import Combine

final class WalletsViewController: UIViewController {
    private let walletsView: WalletsView = WalletsView()
    private let walletsModel: WalletsModel<DispatchQueue>
    private let walletsTableDataSource: WalletsTableDataSource<DispatchQueue>
    private var bag = Set<AnyCancellable>()
    
    init(repository: WalletRepositoryProtocol) {
        self.walletsModel = WalletsModel(repository: repository, on: DispatchQueue.main)
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
        walletsModel.initialFetch()
    }
}
