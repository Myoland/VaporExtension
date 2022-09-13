//
//  File.swift
//  
//
//  Created by AFuture D on 2022/9/6.
//

import Foundation

struct ScopeWarpper {
    let scope: Scope?
    let raw: String
    init(raw: String) {
        self.raw = raw
        self.scope = Scope(raw: raw)
    }
}

extension ScopeWarpper: Equatable {
    static func == (lhs: ScopeWarpper, rhs: ScopeWarpper) -> Bool {
        if let ls = lhs.scope, let rs = rhs.scope {
            return ls == rs
        }
        return lhs.raw == rhs.raw
    }
    
    static func <= (lhs: ScopeWarpper, rhs: ScopeWarpper) -> Bool {
        if let ls = lhs.scope, let rs = rhs.scope {
            return ls <= rs
        }
        return lhs.raw == rhs.raw
    }
    
    static func >= (lhs: ScopeWarpper, rhs: ScopeWarpper) -> Bool {
        if let ls = lhs.scope, let rs = rhs.scope {
            return ls >= rs
        }
        return lhs.raw == rhs.raw
    }
}
