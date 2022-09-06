//
//  File.swift
//  
//
//  Created by AFuture D. on 2022/7/18.
//

import Foundation
import Vapor


/// 用户 Scope 认证中间件
struct ScopeHelper: AsyncMiddleware {
    var scopes: [String]

    init(_ scopes: [String]) {
        self.scopes = scopes
    }
    
    init(scope: String) {
        self.init([scope])
    }
    
    func respond(
        to request: Request,
        chainingTo next: AsyncResponder
    ) async throws -> Response {
        // try request.oauth.assertScopes(self.scopes, as: T.Type)
        
        return try await next.respond(to: request)
    }
}
