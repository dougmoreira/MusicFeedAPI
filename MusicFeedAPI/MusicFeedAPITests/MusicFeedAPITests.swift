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
    
    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "test", code: .zero)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResonse() {
        let (sut, client) = makeSUT()
        
        let errorCodes = [199, 201, 300, 400, 500]
        
        errorCodes.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
}

/// Helpers
extension MusicFeedAPITests {
    private func makeSUT(
        url: URL = URL(string: "any-url")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: MusicFeedLoader, client: HTTPClientSpy) {
        let clientSpy = HTTPClientSpy()
        let sut = MusicFeedLoader(client: clientSpy, url: url)
        
        trackForMemoryLeaks(clientSpy, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, clientSpy)
    }
    
    func expect(_ sut: MusicFeedLoader, toCompleteWith expectedResult: Result<[MusicFeedModel], MusicFeedLoaderError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
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
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
