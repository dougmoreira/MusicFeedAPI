//
//  FeedMusicMapper.swift
//  MusicFeedAPI
//
//  Created by Douglas Moreira on 15/04/23.
//

import Foundation

final class FeedMusicMapper {
    private init() {}

    private struct Root: Decodable {
        let items: [Item]

        var feed: [MusicFeedModel] {
            return items.map { $0.item }
        }
    }

    private struct Item: Decodable {
        let id: String
        let description: String
        
        enum CodingKeys: String, CodingKey {
            case id = "music_id"
            case description = "music_desc"
        }

        var item: MusicFeedModel {
            return MusicFeedModel(id: id, description: description)
        }
    }

    static func map(_ data: Data, from response: HTTPURLResponse) -> MusicFeedLoaderProtocol.Result {
        guard response.statusCode == 200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(MusicFeedLoaderError.invalidData)
        }

        return .success(root.feed)
    }
}
