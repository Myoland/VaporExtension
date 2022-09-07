//
//  File.swift
//  
//
//  Created by AFuture D. on 2022/7/18.
//

import Foundation
import Vapor


/// 用户 Scope 认证中间件
struct ScopeHelper<T: ScopeCarrier>: AsyncMiddleware {
    var scopes: [String]
    var payload: T.Type

    init(_ scopes: [String], as payload: T.Type = T.self) {
        self.scopes = scopes
        self.payload = payload
    }
    
    init(scope: String, as payload: T.Type = T.self) {
        self.init([scope], as: payload.self)
    }
    
    func respond(
        to request: Request,
        chainingTo next: AsyncResponder
    ) async throws -> Response {
        try request.oauth.assertScopes(self.scopes, as: payload.self)
        
        return try await next.respond(to: request)
    }
}
