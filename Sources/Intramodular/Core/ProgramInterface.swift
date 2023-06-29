//
// Copyright (c) Vatsal Manot
//

import Merge
import Swift

/// A type that represents an API.
public protocol ProgramInterface: Identifiable {
    /// The root of this API.
    associatedtype Root: ProgramInterface = Self where Request == Root.Request
    
    /// The request type associated with this API.
    associatedtype Request: SwiftAPI.Request
    
    /// The error type associated with this API.
    associatedtype Error: APIErrorProtocol = _DefaultAPIError<Self> where Error.API == Self
    
    /// The data schema of this API.
    associatedtype Schema = Never
}

// MARK: - Helpers

public struct EmptyProgramInterface<Root: ProgramInterface, Request: SwiftAPI.Request, Error: APIErrorProtocol> {
    public init() {
        
    }
}
