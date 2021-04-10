//
//  WalletsFlowController.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import UIKit

final class WalletsFlowController: FlowController {
    private(set) lazy var rootViewController: UINavigationController = configureRootViewController()
    private let walletRepository: WalletRepositoryProtocol
    
    init() {
        guard let url = Bundle.main.url(forResource: "Masterdata", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url),
              let repository = WalletJsonRepository(jsonData: jsonData)
        else {
            assert(false, "Json file not found or repository faild to init!")
        }
        walletRepository = repository
    }
    
    func configureRootViewController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: WalletsViewController(repository: walletRepository, on: DispatchQueue.main))
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = UIColor(named: "PrimaryColor")
        return navigationController
    }
}

