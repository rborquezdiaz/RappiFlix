//
//  MovieListPresenter.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 04/06/21.
//

import Foundation

class MovieListPresenter : AnyPresenter {
    var router: AnyRouter?
    var interactor: AnyInteractor?
    var view: AnyView?
    var movies: [Movie]?
    
    init(movies : [Movie]) {
        self.movies = movies
    }
    
    func requestListUpdate(currentPage: Int, movieListType: MovieListType) {
        guard let interactor = interactor as? MovieListInteractor else { return }
        //Request for interactor
        interactor.getNextMovieList(currentPage: currentPage, movieListType: movieListType)
    }
    
    func interactorDidFetchMovieList(with result: Result<MovieList, NetworkError>) {
        switch result {
        case .success(let movieList):
            view?.update(with: movieList)
            print(movieList)
        case .failure(let error):
            view?.update(with: error.description)
        }
    }
}
