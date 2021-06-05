//
//  MoviePresenter.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 01/06/21.
//

import Foundation

class HomePresenter : AnyPresenter {
    var router: AnyRouter?
    var interactor: AnyInteractor? {
        didSet {
            guard let homeInteractor = interactor as? HomeInteractor else { return }
            homeInteractor.getHomeMovieList()
        }
    }
    var view: AnyView?
    
    func interactorDidFetchMovies(with result: Result<[MovieList], NetworkError>) {
        switch result {
        case .success(let movies):
            view?.update(with: movies)
            print(movies)
        case .failure(let error):
            view?.update(with: error.description)
        }
    }
}
