//
// Copyright (c) Vatsal Manot
//

import Swallow

/// A resource accessor.
public protocol ResourceAccessor: PropertyWrapper {
    associatedtype Resource: ResourceProtocol where Resource.Value == Value
    associatedtype Value where WrappedValue == Optional<Value>
    
    var wrappedValue: Value? { get }
}
