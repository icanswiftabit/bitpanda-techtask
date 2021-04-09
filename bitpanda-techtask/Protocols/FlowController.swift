//
//  FlowController.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Foundation

protocol FlowController {
    associatedtype RootViewController
    var rootViewController: RootViewController { get }
}
