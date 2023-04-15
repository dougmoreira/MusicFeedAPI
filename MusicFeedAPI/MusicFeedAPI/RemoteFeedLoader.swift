//
//  RemoteFeedLoader.swift
//  MusicFeedAPI
//
//  Created by Douglas Moreira on 15/04/23.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    public func load(completion: @escaping (Result) -> Void) {
        
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
