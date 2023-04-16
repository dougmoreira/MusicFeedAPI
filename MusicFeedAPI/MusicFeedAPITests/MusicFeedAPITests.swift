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
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
        
    }
    
    func test_load_shouldRequestDataFromURLOnce() {
        let url = URL(string: "other-url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.getCallCount, 1)
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
}

extension MusicFeedAPITests {
    private func makeSUT(url: URL = URL(string: "any-url")!) -> (sut: RemoteMusicFeedLoader, client: HTTPClientSpy) {
        let clientSpy = HTTPClientSpy()
        let sut = RemoteMusicFeedLoader(client: clientSpy, url: url)
        
        return (sut, clientSpy)
    }
    
    func expect(_ sut: RemoteMusicFeedLoader, toCompleteWith expectedResult: Result<[FeedMusicModel], MusicFeedLoaderError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        waitForExpectations(timeout: 0.1)
    }
}

public class HTTPClientSpy: HTTPClient {
    public var requestedURLs: [URL] {
        messages.map { $0.url }
    }
    
    public private(set) var getCallCount: Int = 0
    public private(set) var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        getCallCount += 1
        messages.append((url, completion))
    }
}
