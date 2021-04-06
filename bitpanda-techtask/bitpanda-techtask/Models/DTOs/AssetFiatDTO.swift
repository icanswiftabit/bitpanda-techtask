//
//  AssetFiatDTO.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 06/04/2021.
//

import Foundation

struct AssetFiatDTO: Decodable {
    struct Attributes: Decodable {
        let name: String
    }
    
    let id: String
    let attributes: Attributes
}
