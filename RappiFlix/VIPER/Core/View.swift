//
//  View.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 30/05/21.
//

import Foundation
import UIKit

protocol AnyView {
    var presenter : AnyPresenter? { get set }
    
    func update(with entity : AnyEntity)
    func update(with entityArray : [AnyEntity])
    func update(with errorMessage : String)
    func setInterfaceMode()
}

extension AnyView {
    func update(with entity : AnyEntity) {}
    func update(with entityArray : [AnyEntity]) {}
    func update(with errorMessage : String) {}
}
