//
//  RemoteFeedLoader.swift
//  MusicFeedAPI
//
//  Created by Douglas Moreira on 15/04/23.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let client: HTTPClient
    private let URL: URL
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.URL = url
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        
    }
    
    
}

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedMusic], Error>
    func load(completion:@escaping (Result) -> Void)
}

public struct FeedMusic: Hashable {
    public let id: String
    public let description: String
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
