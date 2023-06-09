//
//  MusicFeedModel.swift
//  MusicFeedAPI
//
//  Created by Douglas Moreira on 15/04/23.
//

public struct MusicFeedModel: Hashable {
    public let id: String
    public let description: String
    
    public init(id: String, description: String) {
        self.id = id
        self.description = description
    }
}

public enum MusicFeedLoaderError: Swift.Error {
    case connectivity
    case invalidData
}
