//
//  AppInjectionService.swift
//  ImmersiveKit
//
//  Created by ImmersiveKit Team on 20/12/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import Foundation
import CoreMotion
import ARKit

//public struct InjectorUnavailable: Error {}
//
//public protocol InjectionService: class {
//    typealias Injector = (Any) -> Void
//
//    var injectors: [AnyHashable: Injector] { get set }
//
//    func addInjector<T>(for type: T.Type, injector: @escaping Injector)
//    func injector<T>(for type: T.Type) -> Injector?
//    func injectDependencies<T>(into object: T)
//}
//
//extension InjectionService {
//
//    public func addInjector<T>(for type: T.Type, injector: @escaping Injector) {
//        injectors[String(reflecting: type)] = injector
//    }
//
//    public func injector<T>(for type: T.Type) -> Injector? {
//        return injectors[String(reflecting: type)]
//    }
//
//    public func injectDependencies<T>(into object: T) {
//        if let inject = injectors[String(reflecting: T.self)] {
//            inject(object)
//        } else {
//            assertionFailure("No injector registered for type \(T.self).")
//        }
//    }
//}
//
//final class AppInjectionService: InjectionService {
//
//    public var injectors: [AnyHashable: Injector] = [:]
//
//    private let motionManager = CMMotionManager()
//    private let arSession = ARSession()
//
//    private let appScene = SCNScene()
//
//    private lazy var motionService = MotionService(motionManager: motionManager, session: arSession)
//
//    public init() {
//        addInjector(for: VRViewController.self) { [unowned motionService, unowned appScene] in
//            let controller = ($0 as? VRViewController)
//
//            controller?.motionService = motionService
//            controller?.world = ImmersiveWorld(scene: appScene)
//            controller?.world.view = controller
//        }
//    }
//}
