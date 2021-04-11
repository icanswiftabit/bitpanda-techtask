//
//  WalletContentView.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import UIKit

struct WalletContentConfiguration: UIContentConfiguration {
    let viewModel: WalletViewModel
    
    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
    }
    
    func makeContentView() -> UIView & UIContentView {
        return WalletContentView(self)
    }
    func updated(for state: UIConfigurationState) -> WalletContentConfiguration {
        return self
    }
}

final class WalletContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet { self.configure(with: configuration) }
    }
    
    private let nameLabel: UILabel = UILabel()
    private let symbolLabel: UILabel = UILabel()
    private let balance: UILabel = UILabel()
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with configuration: UIContentConfiguration) {
        guard let configuration = configuration as? WalletContentConfiguration else { return }
        // viewmodel configuration
        nameLabel.text = configuration.viewModel.name
        symbolLabel.text = configuration.viewModel.symbol
        balance.text = configuration.viewModel.balance
        layoutIfNeeded()
    }
}


