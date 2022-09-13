//
//  File.swift
//  
//
//  Created by AFuture D on 2022/9/13.
//

import Vapor
import JWT

public protocol ScopeCarrier: JWTPayload, Authenticatable {
    var scopes: [String] { get }
}

extension ScopeCarrier {
    public static func authenticator() -> ScopeCarrierAuthenticator<Self> {
        ScopeCarrierAuthenticator<Self>()
    }
    
    func authenticate(request: Request) async throws {
        request.auth.login(self)
    }
}

public struct ScopeCarrierAuthenticator<Payload>: AsyncJWTAuthenticator
    where Payload: ScopeCarrier
{
    public func authenticate(jwt: Payload, for request: Request) async throws {
        try await jwt.authenticate(request: request)
    }
}
