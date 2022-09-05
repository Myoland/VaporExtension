//
//  File.swift
//  
//
//  Created by AFuture D. on 2022/7/23.
//

import Foundation
import Vapor

/// The sugar for create routes with Scoped MiddleWare
///
/// Example:
/// routes.grouped("path").scoped("resource") { routes in
///     routes.scoped("subSourece")
///         .with(action: "a") {
///             $0.get(":id", use: ...)
///         }
/// }
/// .with(action: "A") { writeAction in
///     writeAction.post(use: ...)
/// }
/// .all { allAction in
///     allAction.delete(":id", use: ...)
/// }

//public struct ScopedRouterBundler {
//    let resource: String
//    let routes: RoutesBuilder
//
//    @discardableResult
//    public func with(action: String, builder: (RoutesBuilder) throws -> ()) rethrows -> Self {
//        try builder(
//            routes.grouped(
//                ScopeHelper(scope: .init(
//                    resource,
//                    action: action
//                ))
//            )
//        )
//        return self
//    }
//
//    public func all( builder: (RoutesBuilder) throws -> ()) rethrows {
//        try builder(
//            routes.grouped(
//                ScopeHelper(scope: .init(
//                    resource,
//                    action: "*"
//                ))
//            )
//        )
//    }
//}
//
//public extension RoutesBuilder {
//    func scoped(_ resource: String, builder: (RoutesBuilder) throws -> ()) rethrows -> ScopedRouterBundler {
//        try builder(self)
//        return ScopedRouterBundler(
//            resource: resource,
//            routes: self
//        )
//    }
//
//    func scoped(_ resource: String) -> ScopedRouterBundler {
//        return self.scoped(resource) { _ in }
//    }
//}
