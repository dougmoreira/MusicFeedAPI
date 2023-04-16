//
//  HTTPClient.swift
//  MusicFeedAPI
//
//  Created by Douglas Moreira on 15/04/23.
//

import Foundation

public protocol HTTPClientProtocol {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
