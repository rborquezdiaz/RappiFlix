//
//  MovieDetailPresenter.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 03/06/21.
//

import Foundation

class MovieDetailPresenter : AnyPresenter {
    var router: AnyRouter?
    var interactor: AnyInteractor? {
        didSet {
            guard let homeInteractor = interactor as? MovieDetailInteractor else { return }
            guard let id = self.movieID else { return }
            homeInteractor.getHomeMovieDetail(movieID: id)
        }
    }
    var view: AnyView?
    var movieID: Int?
    
    init(movieID : Int) {
        self.movieID = movieID
    }
    
    func interactorDidFetchMovieDetail(with result: Result<Movie, NetworkError>) {
        switch result {
        case .success(let movie):
            view?.update(with: movie)
            print(movie)
        case .failure(let error):
            view?.update(with: error.description)
        }
    }
}
