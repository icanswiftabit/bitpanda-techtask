//
//  AssetsView.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import UIKit
import Combine

final class AssetsView: UIView {    
    @Published private(set) var selectedSegment: AssetsModel.SelectedAssetType = .cryptos
    
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

    private let segmentControl: UISegmentedControl = UISegmentedControl(items: ["Cryptos", "Commodities", "Fiats"])
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

private extension AssetsView {
    func setUpBindings() {
        segmentControl.publisher(for: \.selectedSegmentIndex).sink { [weak self] tab in
            guard let selectedAssetType = AssetsModel.SelectedAssetType(rawValue: tab) else { assert(false, "SelectedAssetType should be created") }
            self?.selectedSegment = selectedAssetType
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
        topTableViewConstraintWithSegmentHidden?.isActive = true
        topTableViewConstraintWithSegmentShowed?.isActive = false
        
        UIView.animate(withDuration: UIConstants.Layout.animation, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
            self.layoutIfNeeded()
            self.segmentControl.alpha = 0
        } completion: { _ in
            self.segmentControl.removeFromSuperview()
        }
    }
    
    func setUpUI() {
        backgroundColor = .systemBackground
        segmentControl.selectedSegmentTintColor = UIColor(named: "PrimaryColor")
        segmentControl.selectedSegmentIndex = selectedSegment.rawValue
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
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
        tableView.register(AssetCell.self)
    }
}

