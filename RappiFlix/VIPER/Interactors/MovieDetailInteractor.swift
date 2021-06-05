//
//  MovieDetailInteractor.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 03/06/21.
//

import Foundation

class MovieDetailInteractor : AnyInteractor {
    var presenter: AnyPresenter?
    var movieDetail : Movie?
    var videos : MovieVideoList?
    
    let movieDetailCache = NSCache<NSNumber, Movie>()
    
    func getHomeMovieDetail(movieID: Int) {
        guard let presenter = presenter as? MovieDetailPresenter else { return }
        
        if let cachedVersion = CentralCache.shared().movieDetailFromCache(key: NSNumber(value: movieID)) {
            // use the cached version
            presenter.interactorDidFetchMovieDetail(with: .success(cachedVersion))
        } else {
            
            let detailDispatchQueue = DispatchQueue(label: "com.detailInteractor.urlQueue")
            let detailDispatchGroup = DispatchGroup()
            
            guard let movieDetailRequest = NetworkManager.shared().urlRequest(for: .movieDetail(movieID)) else { return }
            guard let movieVideosDetailRequest = NetworkManager.shared().urlRequest(for: .movieVideos(movieID)) else { return }
            
            detailDispatchGroup.enter()
            let detailDataTask = NetworkManager.shared().session.dataTask(with: movieDetailRequest) { [weak self] (data, response, error) in
                
                //TODO: Parse
                
                let result = NetworkManager.shared().responseResult(statusCode: response?.getStatusCode() ?? 0)
                
                switch result {
                case .success(_):
                    guard let movieEntity = data?.getDecodedObject(from: Movie.self) else {
                        presenter.interactorDidFetchMovieDetail(with: .failure(.badParse))
                        return
                    }

                    self?.movieDetail = movieEntity
                    
                case .failure(let error):
                    print(error)
                    presenter.interactorDidFetchMovieDetail(with: .failure(ErrorHandler.requestErrorFrom(statusCode: response?.getStatusCode() ?? 0)))
                }

                detailDispatchGroup.leave()
                
                
            }
            detailDataTask.resume()
            
            detailDispatchGroup.enter()
            let movieVideosDataTask = NetworkManager.shared().session.dataTask(with: movieVideosDetailRequest) { [weak self] (data, response, error) in
                
                guard let movieVideosEntity = data?.getDecodedObject(from: MovieVideoList.self) else {
                    presenter.interactorDidFetchMovieDetail(with: .failure(.badParse))
                    return
                }

                self?.videos = movieVideosEntity
                
                
                detailDispatchGroup.leave()
            }
            movieVideosDataTask.resume()
            
            
            detailDispatchGroup.notify(queue: detailDispatchQueue) {
                guard let movieDetail = self.movieDetail, let movieVideos = self.videos, let id = movieDetail.id else {
                    presenter.interactorDidFetchMovieDetail(with: .failure(.badParse))
                    return
                }
                
                movieDetail.videos = movieVideos
                
                CentralCache.shared().updateMovieDetailCache(key: NSNumber(value: id), movie: movieDetail)
                                
                presenter.interactorDidFetchMovieDetail(with: .success(movieDetail))
            }
            
        }
        
    }
}
