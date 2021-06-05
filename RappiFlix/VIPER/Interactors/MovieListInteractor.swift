//
//  MovieListInteractor.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 04/06/21.
//

import Foundation

class MovieListInteractor : AnyInteractor {
    var presenter: AnyPresenter?
    
    func getNextMovieList(currentPage: Int, movieListType: MovieListType) {
        guard let presenter = presenter as? MovieListPresenter else { return }
        
        var movieListRequest : URLRequest?
        switch movieListType {
        case .popular:
            guard let request = NetworkManager.shared().urlRequest(for: .popularMovies(currentPage + 1)) else { return }
            movieListRequest = request
        case .topRated:
            guard let request = NetworkManager.shared().urlRequest(for: .topRatedMovies(currentPage + 1)) else { return }
            movieListRequest = request
        case .upcoming:
            guard let request = NetworkManager.shared().urlRequest(for: .upcomingMovies(currentPage + 1)) else { return }
            movieListRequest = request
        default:
            return
        }
        
        guard let validatedMovieListRequest = movieListRequest else { return }
        
        NetworkManager.shared().session.dataTask(with: validatedMovieListRequest) { (data, response, error) in
            let result = NetworkManager.shared().responseResult(statusCode: response?.getStatusCode() ?? 0)
            
            switch result {
            case .success(_):
                guard let movieListEntity = data?.getDecodedObject(from: MovieList.self) else {
                    presenter.interactorDidFetchMovieList(with: .failure(.badParse))
                    return
                }
                movieListEntity.type = movieListType
                presenter.interactorDidFetchMovieList(with: .success(movieListEntity))
                
            case .failure(let error):
                print(error)
                presenter.interactorDidFetchMovieList(with: .failure(ErrorHandler.requestErrorFrom(statusCode: response?.getStatusCode() ?? 0)))
            }
        }.resume()
    }
}
