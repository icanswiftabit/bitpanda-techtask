//
//  WalletsTableDataSource.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import UIKit
import Combine

final class WalletsTableDataSource<S>: NSObject, UITableViewDataSource where S: Scheduler {
    private let walletsModel: WalletsModel<S>
    
    init(walletsModel: WalletsModel<S>) {
        self.walletsModel = walletsModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        walletsModel.currentlySelectedWallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let model = walletsModel.currentlySelectedWallets[indexPath.row]
        if let model = model as? WalletViewModel {
            let cell = tableView.dequeue(WalletCell.self)
            cell.configure(with: model)
            return cell
        } else if let model = model as? WalletFiatViewModel {
            let cell = tableView.dequeue(FiatWalletCell.self)
            cell.configure(with: model)
            return cell
        }
        
        return UITableViewCell()
    }
}
