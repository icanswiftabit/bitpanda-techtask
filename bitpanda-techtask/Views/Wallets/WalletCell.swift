//
//  WalletCell.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import UIKit

final class WalletCell: UITableViewCell, ReusableCell {
    
    private let nameLabel: UILabel = UILabel()
    private let symbolLabel: UILabel = UILabel()
    private let balance: UILabel = UILabel()
    private let defaultWalletIcon: UIImageView = UIImageView(image: UIImage(systemName: "star.fill"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: WalletViewModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        balance.text = viewModel.balance
        defaultWalletIcon.isHidden = !viewModel.isDefault
    }
}

private extension WalletCell {
    func setUpUI() {
        contentView.backgroundColor = .systemBackground
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIConstants.Font.regular
        
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.font = UIConstants.Font.light
        
        balance.translatesAutoresizingMaskIntoConstraints = false
        balance.font = UIConstants.Font.regular
        
        defaultWalletIcon.translatesAutoresizingMaskIntoConstraints = false
        defaultWalletIcon.contentMode = .scaleAspectFit
        defaultWalletIcon.tintColor = UIColor(named: "PrimaryColor")
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(balance)
        contentView.addSubview(defaultWalletIcon)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.Layout.margin),
            nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: UIConstants.Layout.innerSpacing),
            
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: UIConstants.Layout.innerSpacing),
            symbolLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: UIConstants.Layout.innerSpacing),
            symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.Layout.margin),
            
            defaultWalletIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: UIConstants.Layout.innerSpacing),
            defaultWalletIcon.widthAnchor.constraint(equalToConstant: UIConstants.Layout.Wallet.defaultWidth),
            defaultWalletIcon.heightAnchor.constraint(equalTo: defaultWalletIcon.widthAnchor),
            defaultWalletIcon.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            
            balance.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            balance.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -UIConstants.Layout.margin)
        ])
    }
}
