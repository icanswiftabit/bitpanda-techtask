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
        assetModel.currentlySelectedAssets.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeue(AssetCell.self)
        cell.setUp(with: assetModel.currentlySelectedAssets[indexPath.row])
        return cell
    }
}
