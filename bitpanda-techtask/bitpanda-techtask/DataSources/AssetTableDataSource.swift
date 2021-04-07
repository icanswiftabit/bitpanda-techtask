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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Asset") else { return UITableViewCell() } // Replace with proper identifier
        switch assetModel.selectedSegment.value {
        case .crypto:
            cell.textLabel?.text = assetModel.crypto.value[indexPath.row].attributes.name
        case .commodities:
            cell.textLabel?.text = assetModel.commodities.value[indexPath.row].attributes.name
        case .fiats:
            cell.textLabel?.text = assetModel.fiats.value[indexPath.row].attributes.name
        }
        
        return cell
    }
}
