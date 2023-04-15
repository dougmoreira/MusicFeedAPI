# MusicFeedAPI

[![Swift Version](https://img.shields.io/badge/swift-5.0-orange.svg)](https://swift.org/)
[![Xcode Version](https://img.shields.io/badge/xcode-14.2-blue.svg)](https://developer.apple.com/xcode/)

MusicFeedAPI is a Swift library that provides an interface for loading music feeds from a remote server via HTTP requests.

## Features

- [x] Load music feeds from a remote server
- [x] Support for HTTP GET requests
- [x] Unit test coverage

## Requirements

- iOS 14.0+
- Xcode 14.2+
- Swift 5.0+

## Installation

- Just clone the repo and run

## Usage

```

import MusicFeedAPI

let loader = RemoteMusicFeedLoader(client: HTTPClient(), url: URL(string: "https://example.com/api/music/feed")!)
loader.load { result in
    switch result {
    case .success(let musicFeed):
        // Do something with musicFeed
    case .failure(let error):
        // Handle error
    }
}

```
