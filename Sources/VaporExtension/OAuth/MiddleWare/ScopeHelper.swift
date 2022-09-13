//
//  File.swift
//  
//
//  Created by AFuture D. on 2022/7/18.
//

import Foundation
import Vapor
import JWT

extension ScopeCarrier {
    public static func guardMiddleware(
        with scopes: [String]
    ) -> ScopeHelper<Self> {
        return ScopeHelper<Self>(scopes)
    }
    
    public static func guardMiddleware(
        with scope: String
    ) -> ScopeHelper<Self> {
        return ScopeHelper<Self>([scope])
    }
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

/// 用户 Scope 认证中间件
public struct ScopeHelper<T: ScopeCarrier>: AsyncMiddleware {
    var scopes: [String]

    init(_ scopes: [String]) {
        self.scopes = scopes
    }
    
    init(scope: String) {
        self.init([scope])
    }
    
    public func respond(
        to request: Request,
        chainingTo next: AsyncResponder
    ) async throws -> Response {
        // Try Login User First
        let payload = try request.jwt.verify(as:T.self)
        try await T.authenticator().authenticate(jwt: payload, for: request)
        
        guard try request.oauth.satisfied(with: self.scopes, as: T.self) else  {
            throw Abort(.unauthorized)
        }
        return try await next.respond(to: request)
    }
}
