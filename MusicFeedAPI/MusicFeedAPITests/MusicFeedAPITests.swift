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

}

extension MusicFeedAPITests {
    private func makeSUT() -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let urlMock = URL(string: "any-url")!
        let clientSpy = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: clientSpy, url: urlMock)
        
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
