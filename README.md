# MusicFeedAPI

[![Swift Version](https://img.shields.io/badge/swift-5.0-orange.svg)](https://swift.org/)
[![Xcode Version](https://img.shields.io/badge/xcode-14.2-blue.svg)](https://developer.apple.com/xcode/)

MusicFeedAPI is a Swift library that provides an interface for loading music feeds from a remote server via HTTP requests.
This repository contains unit tests for the MusicFeedAPI module, which provides a loader for retrieving music feed data from a remote server.

## Features

- [x] Load music feeds from a remote server
- [x] Unit test coverage

## Tests

The `MusicFeedAPITests.swift` file contains several unit tests for the MusicFeedAPI module. These tests use a mock implementation of the HTTPClient protocol to simulate data retrieval from the remote server and test various scenarios, such as connectivity errors, invalid data errors, and successful retrieval of data. To run the tests, simply build and run the `CI` scheme in Xcode.
