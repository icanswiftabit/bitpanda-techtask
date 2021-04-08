//
//  ReusableCell.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import UIKit

protocol ReusableCell {
    static var identifier: String { get }
}

extension ReusableCell {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableView {
    func register<T>(_ type: T.Type) where T: ReusableCell, T: UITableViewCell {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeue<T>(_ type: T.Type) -> T where T: ReusableCell, T: UITableViewCell {
        dequeueReusableCell(withIdentifier: T.identifier) as! T
    }
}
