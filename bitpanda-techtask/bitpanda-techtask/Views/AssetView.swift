//
//  AssetView.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import UIKit
import Combine

final class AssetView: UIView {    
    let selectedSegment: CurrentValueSubject<AssetModel.SelectedAssetType, Never> = CurrentValueSubject(.crypto)
    
    let reloadData: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    var dataSoruce: UITableViewDataSource? {
        get { tableView.dataSource }
        set { tableView.dataSource = newValue }
    }
    
    private struct Constants {
        static let topMargin: CGFloat = 12.0
    }
    private let segmentControl: UISegmentedControl = UISegmentedControl(items: ["Crypto", "Commodities", "Fiats"])
    private let tableView: UITableView = UITableView()
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        setUpBindings()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AssetView {
    func setUpBindings() {
        segmentControl.publisher(for: \.selectedSegmentIndex).sink { [weak self] tab in
            guard let selectedAssetType = AssetModel.SelectedAssetType(rawValue: tab) else { assert(false, "SelectedAssetType should be created") }
            self?.selectedSegment.send(selectedAssetType)
        }
        .store(in: &bag)
        
        reloadData.sink { [weak self] in
            self?.tableView.reloadData()
        }
        .store(in: &bag)
    }
    
    func setUpUI() {
        backgroundColor = .systemBackground
        segmentControl.selectedSegmentTintColor = UIColor(named: "PrimaryColor")
        segmentControl.selectedSegmentIndex = selectedSegment.value.rawValue
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(segmentControl)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Asset")
        tableView.allowsSelection = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            segmentControl.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            segmentControl.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: Constants.topMargin),
            
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

