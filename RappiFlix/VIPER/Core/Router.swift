//
//  Router.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 30/05/21.
//

import Foundation
import UIKit

typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    var entry : EntryPoint? { get set }
    
    static func start() -> AnyRouter
    static func start(with id: Int) -> AnyRouter
    static func start(with entity: AnyEntity) -> AnyRouter
}
