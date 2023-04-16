//
//  MusicFeedAPITests+Helpers.swift
//  MusicFeedAPITests
//
//  Created by Douglas Moreira on 16/04/23.
//

import Foundation
import MusicFeedAPI
import XCTest

extension MusicFeedAPITests {
    func makeSUT(
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
    
    func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
