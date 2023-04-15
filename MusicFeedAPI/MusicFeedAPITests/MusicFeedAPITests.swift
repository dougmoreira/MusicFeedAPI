//
//  MusicFeedAPITests.swift
//  MusicFeedAPITests
//
//  Created by Douglas Moreira on 15/04/23.
//

import XCTest

@testable import MusicFeedAPI

final class MusicFeedAPITests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.passedURL)
        
    }
    
    func test_load_shouldRequestDataFromURLOnce() {
        let url = URL(string: "other-url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.getCallCount, 1)
        XCTAssertEqual(client.passedURL, url)
    }

}

extension MusicFeedAPITests {
    private func makeSUT(url: URL = URL(string: "any-url")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let clientSpy = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: clientSpy, url: url)
        
        return (sut, clientSpy)
    }
}

public class HTTPClientSpy: HTTPClient {
    
    public private(set) var getCallCount: Int = 0
    public private(set) var passedURL: URL?
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        getCallCount += 1
        passedURL = url
    }
}
