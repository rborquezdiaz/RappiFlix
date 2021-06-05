//
//  MovieListRouter.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 04/06/21.
//

import Foundation

class MovieListRouter: AnyRouter {
    
    static func start(with entity: AnyEntity) -> AnyRouter {
        let router = MovieListRouter()
        
        guard let movieListEntity = entity as? MovieList else { return MovieListRouter()}
        
        var view: AnyView = MovieListViewController()
        var presenter : AnyPresenter = MovieListPresenter(movies: movieListEntity.results ?? [Movie]())
        var interactor : AnyInteractor = MovieListInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
    var entry: EntryPoint?

    static func start() -> AnyRouter { return MovieListRouter() }
    static func start(with id: Int) -> AnyRouter { return MovieListRouter() }
}
