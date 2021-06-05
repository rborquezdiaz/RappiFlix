//
//  Interactor.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 30/05/21.
//

import Foundation

protocol AnyInteractor {
    var presenter : AnyPresenter? { get set }
}
