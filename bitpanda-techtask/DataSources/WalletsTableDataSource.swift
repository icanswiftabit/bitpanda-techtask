//
//  WalletsTableDataSource.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import UIKit

final class WalletsTableDataSource: NSObject, UITableViewDataSource {
    private let walletsModel: WalletsModel
    
    init(walletsModel: WalletsModel) {
        self.walletsModel = walletsModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        walletsModel.currentlySelectedAssets.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        let cell = tableView.dequeue(AssetCell.self)
//        cell.setUp(with: walletsModel.currentlySelectedAssets[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell")!
        let model = walletsModel.currentlySelectedAssets[indexPath.row]
        if let model = model as? WalletViewModel {
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = "WalletViewModel"
        } else if let model = model as? WalletFiatViewModel {
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = "WalletFiatViewModel"
        }
        
        return cell
    }
}
