//
//  WalletDTO.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 10/04/2021.
//

import Foundation

struct WalletDTO: Decodable {
    struct Attributes: Decodable {
        let name: String
    }
    
    let id: String
    let attributes: Attributes
}
