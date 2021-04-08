//
//  SVGImageProcessor.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import Foundation
import Kingfisher
import SVGKit

//Based on https://github.com/onevcat/Kingfisher/issues/1225
public struct SVGProcessor: ImageProcessor {
    public var identifier: String = "pl.icanswiftabit.bitpanda-techtask.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image): return image
        case .data(let data): return SVGKImage(data: data)?.uiImage
        }
    }
}
