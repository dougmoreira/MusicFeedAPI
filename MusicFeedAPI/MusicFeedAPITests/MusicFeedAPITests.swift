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
    private func makeSUT(url: URL = URL(string: "any-url")!) -> (sut: MusicFeedLoader, client: HTTPClientSpy) {
        let clientSpy = HTTPClientSpy()
        let sut = MusicFeedLoader(client: clientSpy, url: url)
        
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
