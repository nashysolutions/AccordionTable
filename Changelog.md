
# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [2.1.0] - 2022-10-12

### Addition

- [Issue 2](https://github.com/nashysolutions/AccordionTable/issues/2) Toggle collapsible sections feature on or off.

## [2.0.0] - 2022-02-02

Introduces a breaking change.

### Removed

The [OrderedDictionary](https://github.com/apple/swift-collections/tree/main/Sources/OrderedCollections/OrderedDictionary) source code has been removed. The interface for maping data has changed to the following.

```swift
public func update(with data: [Section: [Row]], animated: Bool = true, completion: (() -> Void)? = nil)
```

## [1.0.0] - 2022-01-20

Initial Release
