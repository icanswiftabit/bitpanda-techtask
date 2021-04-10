//
//  AssetsFlowController.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import UIKit

final class AssetsFlowController: FlowController {
    private(set) lazy var rootViewController: UINavigationController = configureRootViewController()
    private let assetRepository: AssetRepositoryProtocol
    
    init() {
        guard let url = Bundle.main.url(forResource: "Masterdata", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url),
              let repository = AssetJsonRepository(jsonData: jsonData)
        else {
            assert(false, "Json file not found or repository faild to init!")
        }
        assetRepository = repository
    }
    
    func configureRootViewController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: AssetsViewController(repository: assetRepository, on: DispatchQueue.main))
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = UIColor(named: "PrimaryColor")
        return navigationController
    }
}
