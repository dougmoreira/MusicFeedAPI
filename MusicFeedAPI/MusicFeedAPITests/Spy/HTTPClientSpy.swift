//
//  HTTPClientSpy.swift
//  MusicFeedAPITests
//
//  Created by Douglas Moreira on 15/04/23.
//

import Foundation
import MusicFeedAPI
import XCTest

public class HTTPClientSpy: HTTPClientProtocol {
    public var requestedURLs: [URL] {
        messages.map { $0.url }
    }
    
    public private(set) var getCallCount: Int = 0
    public private(set) var messages = [(url: URL, completion: (HTTPClientProtocol.Result) -> Void)]()
    
    public func get(from url: URL, completion: @escaping (HTTPClientProtocol.Result) -> Void) {
        getCallCount += 1
        messages.append((url, completion))
    }
    
    func complete(with error: Error, at index: Int = 0, file: StaticString = #filePath, line: UInt = #line) {
        guard messages.count > index else {
            return XCTFail("Can't complete request never made", file: file, line: line)
        }

        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0, file: StaticString = #filePath, line: UInt = #line) {
        guard requestedURLs.count > index else {
            return XCTFail("Can't complete request never made", file: file, line: line)
        }

        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!

        messages[index].completion(.success((data, response)))
    }
}
