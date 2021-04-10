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
    let showSegmentControl: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    var dataSoruce: UITableViewDataSource? {
        get { tableView.dataSource }
        set { tableView.dataSource = newValue }
    }
    
    var delegate: UITableViewDelegate? {
        get { tableView.delegate }
        set { tableView.delegate = newValue }
    }
    
    private let segmentControl: UISegmentedControl = UISegmentedControl(items: ["Wallets", "Commodities", "Fiats"])
    private let tableView: UITableView = UITableView()
    private var topTableViewConstraintWithSegmentShowed: NSLayoutConstraint?
    private var topTableViewConstraintWithSegmentHidden: NSLayoutConstraint?
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
            self?.updateSelectedSegment(with: tab)
        }
        .store(in: &bag)
        
        reloadData.sink { [weak self] in
            self?.tableView.reloadData()
        }
        .store(in: &bag)
        
        showSegmentControl.sink { [weak self] show in
            show ? self?.addSegmentControl() : self?.removeSegmentControl()
        }
        .store(in: &bag)
    }
    
    func addSegmentControl() {
        updateSelectedSegment(with: segmentControl.selectedSegmentIndex)
        addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            segmentControl.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: UIConstants.Layout.margin)
        ])
        layoutIfNeeded()
        
        topTableViewConstraintWithSegmentHidden?.isActive = false
        topTableViewConstraintWithSegmentShowed?.isActive = true
        
        UIView.animate(withDuration: UIConstants.Layout.animation, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
            self.layoutIfNeeded()
            self.segmentControl.alpha = 1
        } completion: { _ in }

    }
    
    func removeSegmentControl() {
        selectedSegment = .all
        topTableViewConstraintWithSegmentHidden?.isActive = true
        topTableViewConstraintWithSegmentShowed?.isActive = false
        
        UIView.animate(withDuration: UIConstants.Layout.animation, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
            self.layoutIfNeeded()
            self.segmentControl.alpha = 0
        } completion: { _ in
            self.segmentControl.removeFromSuperview()
        }
    }
    
    func updateSelectedSegment(with tab: Int) {
        guard let selectedAssetType = WalletsModel.SelectedWalletType(rawValue: tab + 1) else { assert(false, "SelectedWalletType should be created") }
        selectedSegment = selectedAssetType
    }
    
    func setUpUI() {
        backgroundColor = .systemBackground
        segmentControl.selectedSegmentTintColor = UIColor(named: "PrimaryColor")
        segmentControl.selectedSegmentIndex = WalletsModel.SelectedWalletType.all.rawValue
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = (UIConstants.Layout.margin * 2) + UIConstants.Layout.Icon.width
        addSubview(tableView)
        
        let topTableViewConstraint = tableView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
        topTableViewConstraintWithSegmentShowed = tableView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: UIConstants.Layout.SegmentControl.height)
        
        NSLayoutConstraint.activate([
            topTableViewConstraint,
            tableView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        topTableViewConstraintWithSegmentHidden = topTableViewConstraint
    }
    
    func setUpCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WalletCell")
    }
}
