////
////  File.swift
////  
////
////  Created by AFuture D. on 2022/7/19.
////
//
//@testable import VaporExtension
//import Foundation
//import Vapor
//import XCTest
//
//final class OAuthHandlerTests: XCTestCase {
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
//    func testMissPayload() async throws {
//        let request = Request(application: app, on: app.eventLoopGroup.next())
//        
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes([])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//    }
//    
//    func test1v1_Scope() async throws {
//        
//        // scope
//        let u = UserPayload.dummy(scope: ["all.part:read"])
//        
//        let encoded = try app.jwt.signers.sign(u)
//        let request = Request(application: app, on: app.eventLoopGroup.next())
//        request.headers.bearerAuthorization = BearerAuthorization(token: encoded)
//
//        XCTAssertEqual(try request.oauth.userID(), u.subject.value)
//        
//        XCTAssertNoThrow(
//            try request.oauth.assertScopes(["all.part:read"])
//        )
//        
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes(["all.part:write"])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//        
//        XCTAssertNoThrow(
//            try request.oauth.assertScopes(["all.part.sub:read"])
//        )
//        
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes(["all.part:*"])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//        
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes(["all:*"])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//    }
//    
//    func test1v1_String() async throws {
//        
//        // string literal
//        let u = UserPayload.dummy(scope: ["all"])
//        
//        let encoded = try app.jwt.signers.sign(u)
//        let request = Request(application: app, on: app.eventLoopGroup.next())
//        request.headers.bearerAuthorization = BearerAuthorization(token: encoded)
//        
//        XCTAssertEqual(try request.oauth.userID(), u.subject.value)
//        
//        XCTAssertNoThrow(
//            try request.oauth.assertScopes(["all"])
//        )
//        
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes(["error"])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//        
//    }
//    
//    func testUserSingle_RequiredHasSub() async throws {
//        
//        // scope
//        let u = UserPayload.dummy(scope: ["all.part:read"])
//        
//        let encoded = try app.jwt.signers.sign(u)
//        let request = Request(application: app, on: app.eventLoopGroup.next())
//        request.headers.bearerAuthorization = BearerAuthorization(token: encoded)
//        
//        XCTAssertEqual(try request.oauth.userID(), u.subject.value)
//        
//        XCTAssertNoThrow(
//            try request.oauth.assertScopes(["all.part:read", "all.part.sub:read"])
//        )
//    }
//    
//    func testUserSingle_RequiredMiss() async throws {
//        
//        // scope
//        let u = UserPayload.dummy(scope: ["all.part:read"])
//        
//        let encoded = try app.jwt.signers.sign(u)
//        let request = Request(application: app, on: app.eventLoopGroup.next())
//        request.headers.bearerAuthorization = BearerAuthorization(token: encoded)
//        
//        XCTAssertEqual(try request.oauth.userID(), u.subject.value)
//        
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes(["all.part:read", "all.part:write"])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//        
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes(["all.part:read", "all.part:*"])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes(["all.part:read", "all:read"])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//        
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes(["all.part:read", "all:*"])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//    }
//    
//    func testUserSingleAll_RequiredMuti() async throws {
//        
//        // scope
//        let u = UserPayload.dummy(scope: ["all.part:*"])
//        
//        let encoded = try app.jwt.signers.sign(u)
//        let request = Request(application: app, on: app.eventLoopGroup.next())
//        request.headers.bearerAuthorization = BearerAuthorization(token: encoded)
//        
//        XCTAssertEqual(try request.oauth.userID(), u.subject.value)
//        
//        XCTAssertNoThrow(
//            try request.oauth.assertScopes(["all.part:read", "all.part:write"])
//        )
//        
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes(["all:read", "all:write", "all:*"])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//    }
//    
//    func testUserMuti_MutiRes_Required() async throws {
//        
//        // scope
//        let u = UserPayload.dummy(scope: ["all.partA:read", "all.partB:*"])
//        
//        let encoded = try app.jwt.signers.sign(u)
//        let request = Request(application: app, on: app.eventLoopGroup.next())
//        request.headers.bearerAuthorization = BearerAuthorization(token: encoded)
//        
//        XCTAssertEqual(try request.oauth.userID(), u.subject.value)
//        
//        // single required scope
//        XCTAssertNoThrow(
//            try request.oauth.assertScopes(["all.partA:read"])
//        )
//        
//        // single required scope with sub action
//        XCTAssertNoThrow(
//            try request.oauth.assertScopes(["all.partB:read"])
//        )
//        
//        // muti required scope
//        XCTAssertNoThrow(
//            try request.oauth.assertScopes(["all.partA:read", "all.partB:write"])
//        )
//        
//        // muti sub required scope
//        XCTAssertNoThrow(
//            try request.oauth.assertScopes(["all.partA.sub:read", "all.partB.sub:*"])
//        )
//        
//        // miss one required scope
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes(["all.partA:*"])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//        
//        // miss one required scope
//        XCTAssertThrowsError(
//            try request.oauth.assertScopes(["all:*", "all.partB:write"])
//        ) { error in
//            XCTAssertEqual((error as? AbortError)?.status, .unauthorized)
//        }
//    }
//    
//    func testUserMuti_MutiRes_Required() throws {
//        let request = Request(application: app, on: app.eventLoopGroup.next())
//        
//        XCTAssertEqual(try request.oauth.isRequested(kid: "aasd"), false)
//        XCTAssertEqual(try request.oauth.isRequested(kid: "aasd"), true)
//    }
//    
//}
