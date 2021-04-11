//
//  WalletCell.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import UIKit
import Combine

final class WalletCell: UITableViewCell, ReusableCell {
    
    private let nameLabel: UILabel = UILabel()
    private let symbolLabel: UILabel = UILabel()
    private let balance: UILabel = UILabel()
    private let defaultWalletIcon: UIImageView = UIImageView(image: UIImage(systemName: "star.fill"))
    private let iconView: UIImageView = UIImageView()
    private let svgLoader = SVGLoader()
    private var bag = Set<AnyCancellable>()
    
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
        
        let placeholder: UIImage = UIImage(systemName: "coloncurrencysign.circle") ?? UIImage()
        svgLoader.publisher(for: viewModel.logoAsset, failsafeImage: placeholder)
            .catch { error -> Empty<UIImage, Never> in Empty<UIImage, Never>(completeImmediately: true) }
            .sink { [weak self] image in
                self?.iconView.image = image
            }
            .store(in: &bag)
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
        
        iconView.clipsToBounds = true
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(balance)
        contentView.addSubview(defaultWalletIcon)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.Layout.margin),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Layout.margin),
            iconView.widthAnchor.constraint(equalToConstant: UIConstants.Layout.Icon.width),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.Layout.margin),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.Layout.margin),
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: UIConstants.Layout.innerSpacing),
            
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: UIConstants.Layout.innerSpacing),
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            defaultWalletIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: UIConstants.Layout.innerSpacing),
            defaultWalletIcon.widthAnchor.constraint(equalToConstant: UIConstants.Layout.Wallet.defaultWidth),
            defaultWalletIcon.heightAnchor.constraint(equalTo: defaultWalletIcon.widthAnchor),
            defaultWalletIcon.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),

            balance.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            balance.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Layout.margin)
        ])
    }
}
