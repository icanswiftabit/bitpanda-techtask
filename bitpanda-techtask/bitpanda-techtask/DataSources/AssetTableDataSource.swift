//
//  AssetTableDataSource.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import UIKit

final class AssetTableDataSource: NSObject, UITableViewDataSource {
    private let assetModel: AssetModel
    
    init(assetModel: AssetModel) {
        self.assetModel = assetModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assetModel.currentlySelectedCountOfAssets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeue(AssetCell.self)
        switch assetModel.selectedSegment.value {
        case .cryptos:
            cell.setUp(with: assetModel.cryptos.value[indexPath.row])
        case .commodities:
            cell.setUp(with: assetModel.commodities.value[indexPath.row])
        case .fiats:
            cell.setUp(with: assetModel.fiats.value[indexPath.row])
        }
        
        return cell
    }
}
