//
//  ViewController.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import UIKit
import Combine

final class AssetsViewController: UIViewController {
    private let assetsView: AssetsView = AssetsView()
    private let assetsModel: AssetsModel<DispatchQueue>
    private let assetsTableDataSource: AssetsTableDataSource<DispatchQueue>
    private var bag = Set<AnyCancellable>()
    
    init(repository: AssetRepositoryProtocol) {
        self.assetsModel = AssetsModel(repository: repository, on: DispatchQueue.main)
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
        assetsModel.initialFetch()
    }
}
