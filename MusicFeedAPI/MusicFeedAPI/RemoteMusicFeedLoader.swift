//
//  RemoteFeedLoader.swift
//  MusicFeedAPI
//
//  Created by Douglas Moreira on 15/04/23.
//

import Foundation

public final class RemoteMusicFeedLoader: MusicFeedLoaderProtocol {
    private let client: HTTPClient
    private let URL: URL
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.URL = url
    }
    
    public func load(completion: @escaping (MusicFeedLoaderProtocol.Result) -> Void) {
        client.get(from: URL) { result in
            
        }
        
    }
    
    
}

public protocol MusicFeedLoaderProtocol {
    typealias Result = Swift.Result<[FeedMusicModel], MusicFeedLoaderError>
    func load(completion:@escaping (Result) -> Void)
}

public struct FeedMusicModel: Hashable {
    public let id: String
    public let description: String
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

public enum MusicFeedLoaderError: Error {
    case connectivity
    case invalidData
}
