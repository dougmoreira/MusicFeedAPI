//
//  RemoteFeedLoader.swift
//  MusicFeedAPI
//
//  Created by Douglas Moreira on 15/04/23.
//

import Foundation

public final class MusicFeedLoader: MusicFeedLoaderProtocol {
    private let client: HTTPClientProtocol
    private let URL: URL
    
    public init(client: HTTPClientProtocol, url: URL) {
        self.client = client
        self.URL = url
    }
    
    public func load(completion: @escaping (MusicFeedLoaderProtocol.Result) -> Void) {
        client.get(from: URL) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(FeedMusicMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

public protocol MusicFeedLoaderProtocol {
    typealias Result = Swift.Result<[MusicFeedModel], MusicFeedLoaderError>
    func load(completion:@escaping (Result) -> Void)
}
