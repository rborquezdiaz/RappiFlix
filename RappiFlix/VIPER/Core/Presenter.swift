//
//  Presenter.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 30/05/21.
//

import Foundation

protocol AnyPresenter {
    var router: AnyRouter? { get set }
    var interactor : AnyInteractor? { get set }
    var view : AnyView? { get set }
}
