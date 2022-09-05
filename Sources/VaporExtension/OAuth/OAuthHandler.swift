//
//  File.swift
//  
//
//  Created by AFuture D. on 2022/7/19.
//

import Foundation
import Vapor
import JWT

public protocol ScopeCarrier: JWTPayload {
    var scopes: [String] { get }
}

//extension Request {
//    struct Key: StorageKey {
//        typealias Value = OAuthHandler
//    }
//
//    public var oauth: OAuthHandler {
//        if let existing = storage[Key.self] {
//            return existing
//        }
//
//        let handler = OAuthHandler(request: self)
//        storage[Key.self] = handler
//
//        return handler
//    }
//}

public class OAuthHandler<T> where T: ScopeCarrier {
    
    weak var request: Request?
    
    init(request: Request?) {
        self.request = request
    }
    
    // Every required scope should smaller than one of the user's permissions.
    func assertScopes(_ requiredScopes: [String]) throws {
        let payload = try self.getPayLoad()
        let userScopes = payload.scopes
        let convertedScopes = userScopes.compactMap {
            Scope(raw: $0)
        }
        for requiredScope in requiredScopes {
            var hasPermission = false
            // try to use Scope first, if not exist than compare raw string
            if convertedScopes.count > 0, let convertedScope = Scope(raw: requiredScope) {
                hasPermission = convertedScopes.contains(convertedScope)
            } else {
                hasPermission = userScopes.contains(requiredScope)
            }
            if !hasPermission {
                throw Abort(.unauthorized)
            }
        }
    }
    
    func getPayLoad() throws -> T {
        guard let request = self.request else {
            throw Abort(.unauthorized)
        }
        
        return try request.jwt.verify(as: T.self)
    }
}
