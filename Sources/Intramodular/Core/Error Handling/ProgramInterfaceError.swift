//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

public protocol ProgramInterfaceError: Error {
    associatedtype Interface: ProgramInterface
    
    static func badRequest(_ error: Interface.Request.Error) -> Self
    static func runtime(_ error: Error) -> Self
}

public enum DefaultProgramInterfaceError<Interface: ProgramInterface>: ProgramInterfaceError {
    case badRequest(Interface.Request.Error)
    case runtime(Error)
}

extension DefaultProgramInterfaceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .badRequest(let error):
                return (error as? LocalizedError)?.localizedDescription ?? error.localizedDescription
            case .runtime(let error):
                return (error as? LocalizedError)?.localizedDescription ?? error.localizedDescription
        }
    }
}
