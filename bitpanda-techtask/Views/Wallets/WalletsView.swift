//
//  WalletsView.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import UIKit
import Combine

final class WalletsView: UIView {
    @Published private(set) var selectedSegment: WalletsModel.SelectedWalletType = .all
    
    let reloadData: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    var dataSoruce: UITableViewDataSource? {
        get { tableView.dataSource }
        set { tableView.dataSource = newValue }
    }
    
    var delegate: UITableViewDelegate? {
        get { tableView.delegate }
        set { tableView.delegate = newValue }
    }
    
    private let segmentControl: UISegmentedControl = UISegmentedControl(items: ["All", "Wallets", "Commodities", "Fiats"])
    private let tableView: UITableView = UITableView()
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        setUpBindings()
        setUpCells()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension WalletsView {
    func setUpBindings() {
        segmentControl.publisher(for: \.selectedSegmentIndex).sink { [weak self] tab in
            guard let selectedAssetType = WalletsModel.SelectedWalletType(rawValue: tab) else { assert(false, "SelectedWalletType should be created") }
            self?.selectedSegment = selectedAssetType
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
        segmentControl.selectedSegmentIndex = selectedSegment.rawValue
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(segmentControl)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = (UIConstants.Layout.margin * 2) + UIConstants.Layout.Icon.width
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            segmentControl.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            segmentControl.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: UIConstants.Layout.margin),
            
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func setUpCells() {
//        tableView.register(WalletCell.self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WalletCell")
    }
}
