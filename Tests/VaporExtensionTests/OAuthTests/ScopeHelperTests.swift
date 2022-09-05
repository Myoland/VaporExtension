////
////  File.swift
////
////
////  Created by AFuture D. on 2022/7/19.
////
//
//@testable import VaporExtension
//import Vapor
//import Foundation
//import XCTest
//
//final class ScopeHelperTests: XCTestCase {
//    
//    var app: Application!
//    
//    // Runs before each test method
//    override func setUp() async throws {
//        app = Application(.testing)
//        try app.jwt.signers.use(jwk: JWTHelper.jwkPrivate, isDefault: true)
//        try app.jwt.signers.use(jwk: JWTHelper.jwk)
//        
//        try await app.autoRevert()
//        try await app.autoMigrate()
//    }
//    
//    // Runs after each test method
//    override func tearDown() async throws {
//        app.shutdown()
//    }
//    
//    func testJWKLoad() async throws {
//        
//        let u = UserPayload (
//            subject: .init(value: "02F6A5B7-6AE1-4AED-8CCE-F013163A9AC7"),
//            expiration: .init(value: Date.init(timeIntervalSinceNow: 3600)),
//            groups: ["Admin"],
//            permissions: ["all"]
//        )
//        let encoded = try app.jwt.signers.sign(u)
//        
//        let decoded = try app.jwt.signers.verify(encoded, as: UserPayload.self)
//        
//        XCTAssertEqual(decoded, u)
//    }
//    
//    func testScopeHelperMissPayload() async throws {
//        
//        app.routes.grouped([
//            ScopeHelper(scope: "one")
//        ]).get("test") { req -> HTTPStatus in
//            return .ok
//        }
//        
//        // if request do not have paylod
//        try app.test(.GET, "test") { res in
//            XCTAssertEqual(res.status, .unauthorized)
//        }
//    }
//    
//    func testScopeHelperSingleScope() async throws {
//        
//        app.routes.grouped([
//            ScopeHelper(scope: "one")
//        ]).get("one") { req -> HTTPStatus in
//            return .ok
//        }
//        
//        app.routes.grouped([
//            ScopeHelper(scope: "two")
//        ]).get("two") { req -> HTTPStatus in
//            return .ok
//        }
//        
//        let u = UserPayload (
//            subject: .init(value: "02F6A5B7-6AE1-4AED-8CCE-F013163A9AC7"),
//            expiration: .init(value: Date.init(timeIntervalSinceNow: 3600)),
//            groups: ["Admin"],
//            permissions: ["one"]
//        )
//        let encoded = try app.jwt.signers.sign(u)
//        
//        // if payload's scopes do not contain the required scope
//        try app.test(.GET, "two", beforeRequest: { req in
//            req.headers.bearerAuthorization = BearerAuthorization(token: encoded)
//        }) { res in
//            XCTAssertEqual(res.status, .unauthorized)
//        }
//        
//        try app.test(.GET, "one", beforeRequest: { req in
//            req.headers.bearerAuthorization = BearerAuthorization(token: encoded)
//        }) { res in
//            XCTAssertEqual(res.status, .ok)
//        }
//    }
//    
//    func testScopeEnsureMiddlewareMutiScope() async throws {
//        
//        app.routes.grouped([
//            ScopeHelper(scope: "one")
//        ]).get("one") { req -> HTTPStatus in
//            return .ok
//        }
//        
//        app.routes.grouped([
//            ScopeHelper(["one", "two"])
//        ]).get("two") { req -> HTTPStatus in
//            return .ok
//        }
//        
//        app.routes.grouped([
//            ScopeHelper(["one", "two", "three"])
//        ]).get("three") { req -> HTTPStatus in
//            return .ok
//        }
//        
//        let u = UserPayload (
//            subject: .init(value: "02F6A5B7-6AE1-4AED-8CCE-F013163A9AC7"),
//            expiration: .init(value: Date.init(timeIntervalSinceNow: 3600)),
//            groups: ["Admin"],
//            permissions: ["one", "two"]
//        )
//        let encoded = try app.jwt.signers.sign(u)
//        
//        try app.test(.GET, "one", beforeRequest: { req in
//            req.headers.bearerAuthorization = BearerAuthorization(token: encoded)
//        }) { res in
//            XCTAssertEqual(res.status, .ok)
//        }
//        
//        try app.test(.GET, "two", beforeRequest: { req in
//            req.headers.bearerAuthorization = BearerAuthorization(token: encoded)
//        }) { res in
//            XCTAssertEqual(res.status, .ok)
//        }
//        
//        // if payload's scopes not reach the required scope
//        try app.test(.GET, "three", beforeRequest: { req in
//            req.headers.bearerAuthorization = BearerAuthorization(token: encoded)
//        }) { res in
//            XCTAssertEqual(res.status, .unauthorized)
//        }
//    }
//}
