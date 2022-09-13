//
//  File.swift
//  
//
//  Created by AFuture D. on 2022/7/19.
//

import Foundation
import Vapor
import JWT

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
        let carried = payload.scopes
        return self.assertScopes(required, carried: carried)
    }
    
    func assertScopes(_ required: [String], carried: [String]) -> Bool {
        
        let carriedWrappers = carried.map { ScopeWarpper(raw: $0) }
        let requiredWrappers = required.map { ScopeWarpper(raw: $0) }
        
        for require in requiredWrappers {
            guard carriedWrappers.contains(where: { require <= $0 }) else  {
                return false
            }
        }
        return true
    }
    
    func getPayLoad<T: ScopeCarrier>(as payload: T.Type = T.self) throws -> T {
        guard let request = self.request else {
            throw Abort(.unauthorized)
        }
        guard let payload = request.auth.get(T.self) else {
            throw Abort(.unauthorized)
        }
        return payload
    }
}
