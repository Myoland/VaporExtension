//
//  File.swift
//  
//
//  Created by AFuture D. on 2022/7/18.
//

import Foundation
import Vapor

extension ScopeCarrier {
    public static func guardMiddleware(
        _ scopes: [String]
    ) -> Middleware {
        return ScopeHelper<Self>(scopes)
    }
}


/// 用户 Scope 认证中间件
struct ScopeHelper<T: ScopeCarrier>: AsyncMiddleware {
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
        guard try request.oauth.satisfied(with: self.scopes, as: T.self) else  {
            throw Abort(.unauthorized)
        }
        return try await next.respond(to: request)
    }
}
