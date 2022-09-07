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

extension Request {
    struct Key: StorageKey {
        typealias Value = OAuthHandler
    }

    public var oauth: OAuthHandler {
        if let existing = storage[Key.self] {
            return existing
        }

        let handler = OAuthHandler(request: self)
        storage[Key.self] = handler

        return handler
    }
}

public class OAuthHandler {
    
    weak var request: Request?
    
    init(request: Request?) {
        self.request = request
    }
    
    func satisfied<T: ScopeCarrier>(with required: [String], as payload: T.Type = T.self) throws -> Bool {
        let payload  = try self.getPayLoad(as: payload)
        let declared = payload.scopes
        return self.assertScopes(required, declared: declared)
    }
    
    func assertScopes(_ required: [String], declared: [String]) -> Bool {
        
        let declaredWrappers = declared.map { ScopeWarpper(raw: $0) }
        let requiredWrappers = required.map { ScopeWarpper(raw: $0) }
        
        for require in requiredWrappers {
            guard declaredWrappers.contains(where: { $0 <= require }) else  {
                return false
            }
        }
        return true
    }
    
    func getPayLoad<T: ScopeCarrier>(as payload: T.Type = T.self) throws -> T {
        guard let request = self.request else {
            throw Abort(.unauthorized)
        }
        
        return try request.jwt.verify(as: payload)
    }
}
