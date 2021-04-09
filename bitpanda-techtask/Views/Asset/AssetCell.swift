//
//  Asset.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import UIKit
import Kingfisher

final class AssetCell: UITableViewCell, ReusableCell {
    let iconView: UIImageView = UIImageView()
    let nameLabel: UILabel = UILabel()
    let symbolLabel: UILabel = UILabel()
    let avgPriceLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(with viewModel: AssetViewModelProtocol) {
        if let assetViewModel = viewModel as? AssetViewModel {
            setUp(with: assetViewModel)
        } else if let assetFiatViewModel = viewModel as? AssetFiatViewModel {
            setUp(with: assetFiatViewModel)
        } else {
            assertionFailure("Type of view model not recognized")
        }
    }
}

private extension AssetCell {
    func setUpUI() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.clipsToBounds = true
        iconView.contentMode = .scaleAspectFit
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIConstants.Font.regular
        
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.font = UIConstants.Font.light
        
        avgPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        avgPriceLabel.font = UIConstants.Font.regular
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(avgPriceLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.Layout.margin),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.Layout.margin),
            iconView.widthAnchor.constraint(equalToConstant: UIConstants.Layout.Icon.width),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.Layout.margin),
            
            nameLabel.topAnchor.constraint(equalTo: iconView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: UIConstants.Layout.innerSpacing),
            
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: UIConstants.Layout.innerSpacing),
            symbolLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: UIConstants.Layout.innerSpacing),
            
            avgPriceLabel.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            avgPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.Layout.margin)
        ])
    }
    
    func setUp(with viewModel: AssetViewModel) {
        let placeholder: UIImage? = UIImage(systemName: "coloncurrencysign.circle")
        iconView.kf.setImage(with: viewModel.iconLightUrl, placeholder: placeholder, options: [.processor(SVGProcessor())])
        nameLabel.text = viewModel.name
        symbolLabel.text = "(\(viewModel.symbol))"

        avgPriceLabel.text = viewModel.averagePrice.price.currency(symbol: "EUR", precision: viewModel.averagePrice.precision)
    }
    
    func setUp(with viewModel: AssetFiatViewModel) {
        let placeholder: UIImage? = UIImage(systemName: "coloncurrencysign.circle")
        iconView.kf.setImage(with: viewModel.iconLightUrl, placeholder: placeholder, options: [.processor(SVGProcessor())])
        nameLabel.text = viewModel.name
        symbolLabel.text = "(\(viewModel.symbol))"
        avgPriceLabel.text = nil
    }
}

private extension String {
    private static let currencyFormatter = NumberFormatter()
    
    func currency(symbol: String, precision: Int) -> String? {
        guard let number = Double(self) else {
            assertionFailure("Currency formatting error")
            return nil
        }
        
        String.currencyFormatter.numberStyle = .currency
        String.currencyFormatter.currencyCode = symbol
        String.currencyFormatter.maximumFractionDigits = precision
        
        guard let returnString = String.currencyFormatter.string(from: NSNumber(floatLiteral: number)) else {
            assertionFailure("Currency formatting error")
            return nil
        }
        
        return returnString
    }
}
