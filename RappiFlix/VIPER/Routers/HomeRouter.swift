//
//  MovieRouter.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 01/06/21.
//

import Foundation

class HomeRouter: AnyRouter {
    var entry: EntryPoint?

    static func start(with id: Int) -> AnyRouter {
        return HomeRouter.start()
    }
    
    static func start() -> AnyRouter {
        let router = HomeRouter()
        
        var view: AnyView = HomeViewController()
        var presenter : AnyPresenter = HomePresenter()
        var interactor : AnyInteractor = HomeInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
    static func start(with entity: AnyEntity) -> AnyRouter {
        return HomeRouter.start()
    }
}
