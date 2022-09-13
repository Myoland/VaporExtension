//
//  File.swift
//  
//
//  Created by AFuture D on 2022/9/13.
//

@testable import VaporExtension
import Foundation
import XCTest

final class ScopeWrapperTests: XCTestCase {
    
    func testWrapperCreate() async throws {
        let a = ScopeWarpper(raw: "recommend.release:read")
        XCTAssertNotNil(a.scope)
        XCTAssertEqual(a.raw, a.scope?.raw)
        
        let b = ScopeWarpper(raw: "recommend.release:*")
        XCTAssertNotNil(b.scope)
        XCTAssertEqual(b.raw, b.scope?.raw)
        
        let c = ScopeWarpper(raw: "recommend.release")
        XCTAssertNil(c.scope)
    }
    
    func testWrapperEqual() async throws {
        let a = ScopeWarpper(raw: "recommend.release:read")
        let b = ScopeWarpper(raw: "recommend.release:read")
        XCTAssertEqual(a, b)
        
        let c = ScopeWarpper(raw: "recommend-common")
        let d = ScopeWarpper(raw: "recommend-common")
        XCTAssertEqual(c, d)
    }
    
    func testWrapperNotEqual() async throws {
        let a = ScopeWarpper(raw: "recommend.release:read")
        let b = ScopeWarpper(raw: "recommend.release:*")
        XCTAssertNotEqual(a, b)
        XCTAssert(a <= b)
        
        let c = ScopeWarpper(raw: "recommend.release")
        XCTAssertNotEqual(a, c)
        XCTAssertFalse(a <= c)
        XCTAssertFalse(a >= c)
    }
}

