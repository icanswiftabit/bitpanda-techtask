//
//  SVGLoader.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 11/04/2021.
//

import UIKit
import Combine
import SVGKit

final class SVGLoader {
    private let urlSession: URLSession
    private let cache: NSCache<NSURL, UIImage>
    private static let defaultCache = NSCache<NSURL, UIImage>()

    init(urlSession: URLSession = .shared, cache: NSCache<NSURL, UIImage> = SVGLoader.defaultCache) {
        self.urlSession = urlSession
        self.cache = cache
    }

    func publisher(for asset: ImageAssetResource, failsafeImage: UIImage) -> AnyPublisher<UIImage, Error> {
        guard let lightUrl = asset.lightUrl else {
            return Just(failsafeImage).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        guard let darkUrl = asset.darkUrl else {
            return publisher(for: lightUrl).eraseToAnyPublisher()
        }
        
        return publisher(for: lightUrl).zip(publisher(for: darkUrl))
            .catch{ _ -> AnyPublisher<(UIImage, UIImage), Error> in
                Just((failsafeImage,failsafeImage)).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .map { image -> UIImage in
                guard let configuration = image.0.configuration else { return image.0 }
                let returnImage = image.0.withConfiguration(configuration.withTraitCollection(UITraitCollection(userInterfaceStyle: .light)))
                returnImage.imageAsset?.register(image.1, with: UITraitCollection(userInterfaceStyle: .dark))
                
                return returnImage
            }
            .eraseToAnyPublisher()
    }
    
    private func publisher(for url: URL) -> AnyPublisher<UIImage, Error> {
        if let image = cache.object(forKey: url as NSURL) {
            return Just(image)
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            
        } else {
            return urlSession.dataTaskPublisher(for: url)
                .map(\.data)
                .tryMap { data in
                    guard let image = SVGKImage(data: data)?.uiImage else {
                        throw URLError(.badServerResponse, userInfo: [
                            NSURLErrorFailingURLErrorKey: url
                        ])
                    }
                    return image
                }
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput: { [weak self] image in
                    self?.cache.setObject(image, forKey: url as NSURL)
                })
                .eraseToAnyPublisher()
        }
    }
}
