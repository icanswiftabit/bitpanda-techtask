//
//  FiatWalletCell.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 11/04/2021.
//

import UIKit
import Combine

final class FiatWalletCell: UITableViewCell, ReusableCell {
    
    private let nameLabel: UILabel = UILabel()
    private let symbolLabel: UILabel = UILabel()
    private let balance: UILabel = UILabel()
    private let fiatIcon: UIImageView = UIImageView(image: UIImage(systemName: "banknote"))
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
    
    func configure(with viewModel: WalletFiatViewModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.fiatSymbol
        balance.text = viewModel.balance
        
        let placeholder: UIImage = UIImage(systemName: "coloncurrencysign.circle") ?? UIImage()
        svgLoader.publisher(for: viewModel.logoAsset, failsafeImage: placeholder)
            .catch { error -> Empty<UIImage, Never> in Empty<UIImage, Never>(completeImmediately: true) }
            .sink { [weak self] image in
                self?.iconView.image = image
            }
            .store(in: &bag)
    }
}

private extension FiatWalletCell {
    func setUpUI() {
        contentView.backgroundColor = .secondarySystemBackground
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIConstants.Font.regular
        
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.font = UIConstants.Font.light
        
        balance.translatesAutoresizingMaskIntoConstraints = false
        balance.font = UIConstants.Font.regular
        
        fiatIcon.translatesAutoresizingMaskIntoConstraints = false
        fiatIcon.contentMode = .scaleAspectFit
        fiatIcon.tintColor = UIColor(named: "PrimaryColor")
        
        iconView.clipsToBounds = true
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(balance)
        contentView.addSubview(fiatIcon)
        
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
            
            fiatIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: UIConstants.Layout.innerSpacing),
            fiatIcon.widthAnchor.constraint(equalToConstant: UIConstants.Layout.Wallet.fiatWidth),
            fiatIcon.heightAnchor.constraint(equalTo: fiatIcon.widthAnchor),
            fiatIcon.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            
            balance.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            balance.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -UIConstants.Layout.margin)
        ])
    }
}

