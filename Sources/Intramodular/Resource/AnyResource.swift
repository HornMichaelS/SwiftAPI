//
// Copyright (c) Vatsal Manot
//

import Merge
import Swift

public protocol _opaque_ResourceProtocol {
    func beginResolutionIfNecessary()
}

public class AnyResource<Value>: ResourceProtocol {
    public let base: _opaque_ResourceProtocol
    public let objectWillChange: AnyObjectWillChangePublisher
    
    let latestValueImpl: () -> Value?
    
    public var latestValue: Value? {
        latestValueImpl()
    }
    
    public init<Resource: ResourceProtocol>(
        _ resource: Resource
    ) where Resource.Value == Value {
        self.base = resource
        self.objectWillChange = .init(from: resource)
        
        self.latestValueImpl = { resource.latestValue }
    }
    
    public func beginResolutionIfNecessary() {
        base.beginResolutionIfNecessary()
    }
}
