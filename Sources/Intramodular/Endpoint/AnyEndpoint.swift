//
// Copyright (c) Vatsal Manot
//

import Merge
import Swift

public struct AnyEndpoint<Root: ProgramInterface, Input, Output>: Endpoint {
    public typealias Request = Root.Request
    
    public typealias BuildRequestContext = EndpointBuildRequestContext<Root, Input, Output>
    public typealias DecodeOutputContext = EndpointDecodeOutputContext<Root, Input, Output>

    private var buildRequestImpl: (_ from: Input, _ context: BuildRequestContext) throws -> Root.Request
    private var decodeOutputImpl: (_ from: Root.Request.Response, _ context: DecodeOutputContext) throws -> Output
    
    public init<E: Endpoint>(_ endpoint: E) where E.Root == Root, E.Input == Input, E.Output == Output {
        self.buildRequestImpl = {
            try endpoint.buildRequest(from: $0, context: $1)
        }
        
        self.decodeOutputImpl = {
            try endpoint.decodeOutput(from: $0, context: $1)
        }
    }
    
    public func buildRequest(
        from input: Input,
        context: BuildRequestContext
    ) throws -> Request {
        try buildRequestImpl(input, context)
    }
    
    public func decodeOutput(
        from response: Request.Response,
        context: DecodeOutputContext
    ) throws -> Output {
        try decodeOutputImpl(response, context)
    }
}

extension AnyEndpoint {
    public mutating func addRequestTransform(_ transform: @escaping (Root.Request) throws -> Root.Request) {
        let oldImpl = buildRequestImpl
        
        buildRequestImpl = { try transform(oldImpl($0, $1)) }
    }
    
    public mutating func addRequestTransform(_ transform: @escaping (Input, Root.Request) throws -> Root.Request) {
        let oldImpl = buildRequestImpl
        
        buildRequestImpl = { try transform($0, oldImpl($0, $1)) }
    }
}
