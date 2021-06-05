//
//  MovieInteractor.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 01/06/21.
//

import Foundation

class HomeInteractor : AnyInteractor {
    var presenter: AnyPresenter?
    var movieListEntities = [MovieList]()
    
    func getHomeMovieList() {
        guard let presenter = presenter as? HomePresenter else { return }
        
        let homeDispatchQueue = DispatchQueue(label: "com.homeInteractor.urlQueue")
        let homeDispatchGroup = DispatchGroup()
        
        guard let popularMoviesrequest = NetworkManager.shared().urlRequest(for: .popularMovies(1)) else { return }
        guard let topRatedMoviesrequest = NetworkManager.shared().urlRequest(for: .topRatedMovies(1)) else { return }
        guard let upcomingMoviesrequest = NetworkManager.shared().urlRequest(for: .upcomingMovies(1)) else { return }
        
        
        homeDispatchGroup.enter()
        let popularDataTask = NetworkManager.shared().session.dataTask(with: popularMoviesrequest) { [weak self] (data, response, error) in
            
            self?.handleMovieListResult(result: NetworkManager.shared().responseResult(statusCode: response?.getStatusCode() ?? 0), data: data, movieListType: .popular, presenter: presenter)
            homeDispatchGroup.leave()
        }
        popularDataTask.resume()
        
        homeDispatchGroup.enter()
        let topRatedDataTask = NetworkManager.shared().session.dataTask(with: topRatedMoviesrequest) { [weak self] (data, response, error) in
            
            self?.handleMovieListResult(result: NetworkManager.shared().responseResult(statusCode: response?.getStatusCode() ?? 0), data: data, movieListType: .topRated, presenter: presenter)
            homeDispatchGroup.leave()
        }
        topRatedDataTask.resume()
        
        homeDispatchGroup.enter()
        let upcomingDataTask = NetworkManager.shared().session.dataTask(with: upcomingMoviesrequest) { [weak self] (data, response, error) in
            
            self?.handleMovieListResult(result: NetworkManager.shared().responseResult(statusCode: response?.getStatusCode() ?? 0), data: data, movieListType: .upcoming, presenter: presenter)
            homeDispatchGroup.leave()
        }
        upcomingDataTask.resume()
        
        homeDispatchGroup.notify(queue: homeDispatchQueue) { [weak self] in
            presenter.interactorDidFetchMovies(with: .success(self?.movieListEntities ?? [MovieList]()))
            self?.movieListEntities.removeAll()
        }
    }
    
    private func handleMovieListResult(result: (Result<Bool, NetworkError>), data: Data?, movieListType : MovieListType, presenter: HomePresenter) {
        switch result {
        case .success(_):
            guard let movieListEntity = data?.getDecodedObject(from: MovieList.self) else {
                presenter.interactorDidFetchMovies(with: .failure(.badParse))
                return
            }
            movieListEntity.type = movieListType
            movieListEntities.append(movieListEntity)
            
        case .failure(let error):
            print(error)
            presenter.interactorDidFetchMovies(with: .failure(error))
        }
    }
}
