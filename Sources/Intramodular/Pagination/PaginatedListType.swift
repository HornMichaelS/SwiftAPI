//
// Copyright (c) Vatsal Manot
//

import Compute
import Swallow
import Swift

public protocol _opaque_PaginatedListType {
    var nextCursor: PaginationCursor? { get }
    
    mutating func setNextCursor(_ cursor: PaginationCursor?) throws
    
    mutating func _opaque_concatenateInPlace(with other: _opaque_PaginatedListType) throws
}

extension _opaque_PaginatedListType where Self: PaginatedListType {
    public mutating func _opaque_concatenateInPlace(with other: _opaque_PaginatedListType) throws {
        try concatenateInPlace(with: cast(other, to: Self.self))
    }
}

public protocol PaginatedListType: _opaque_PaginatedListType, Partializable {
    associatedtype Partial
    
    var nextCursor: PaginationCursor? { get }
    
    mutating func setNextCursor(_ cursor: PaginationCursor?) throws
    mutating func concatenateInPlace(with other: Self) throws
}

extension ResourceType where Value: PaginatedListType {
    public func fetchAllNext() -> AnyTask<Value, Error> {
        Publishers.While(self.latestValue?.nextCursor != nil) {
            self.fetch().successPublisher
        }
        .convertToTask()
        .mapTo({ self.latestValue })
        .tryMap({ try $0.unwrap() })
        .convertToTask()
    }
}
