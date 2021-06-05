//
//  MovieDetailRouter.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 03/06/21.
//

import Foundation

class MovieDetailRouter: AnyRouter {
    var entry: EntryPoint?

    static func start() -> AnyRouter { return MovieDetailRouter() }
    
    static func start(with entity: AnyEntity) -> AnyRouter { return MovieDetailRouter() }
    
    static func start(with id: Int) -> AnyRouter {
        let router = MovieDetailRouter()
        
        var view: AnyView = MovieDetailViewController()
        var presenter : AnyPresenter = MovieDetailPresenter(movieID: id)
        var interactor : AnyInteractor = MovieDetailInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
}
