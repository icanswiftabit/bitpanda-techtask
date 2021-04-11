//
//  AssetsTableDataSource.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import UIKit

final class AssetsTableDataSource<S>: NSObject, UITableViewDataSource where S: DispatchQueue {
    private let assetsModel: AssetsModel<S>
    
    init(assetsModel: AssetsModel<S>) {
        self.assetsModel = assetsModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assetsModel.currentlySelectedAssets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeue(AssetCell.self)
        cell.setUp(with: assetsModel.currentlySelectedAssets[indexPath.row])
        return cell
    }
}
