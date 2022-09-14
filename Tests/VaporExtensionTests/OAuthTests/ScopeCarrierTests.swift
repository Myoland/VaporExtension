//
//  File.swift
//
//
//  Created by AFuture D. on 2022/7/19.
//

@testable import VaporExtension
import Foundation
import Vapor
import XCTest
import XCTVapor

final class ScopeCarrierTests: XCTestCase {
    
    var app: Application!
    
    override func setUp() async throws {
        app = Application(.testing)
        try app.jwt.signers.use(jwk: JWTHelper.jwkPrivate, isDefault: true)
        try app.jwt.signers.use(jwk: JWTHelper.jwk)
    }
    
    override func tearDown() async throws {
        app.shutdown()
    }
    
    func testCarrierLogin() async throws {
        // scope
        let u = User.dummy(scope: ["all.part:read"])

        let request = Request(application: app, on: app.eventLoopGroup.next())
        try await User.authenticator().authenticate(jwt: u, for: request)

        XCTAssertNotNil(request.auth.get(User.self))
    }
    
    func testCarrierEncode() async throws {
        let u = User.dummy(scope: ["all.part:read"])

        let encoded = try app.jwt.signers.sign(u)
        let request = Request(application: app, on: app.eventLoopGroup.next())
        
        request.headers.bearerAuthorization = BearerAuthorization(token: encoded)
        
        let payload = try request.jwt.verify(as:User.self)
        XCTAssertEqual(u, payload)
        
        try await User.authenticator().authenticate(jwt: payload, for: request)
        XCTAssertNotNil(request.auth.get(User.self))
    }
}
