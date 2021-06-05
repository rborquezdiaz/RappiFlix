//
//  CentralCache.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 04/06/21.
//

import Foundation

public class CentralCache {
    
    private static var sharedInstance: CentralCache = {
        let centralCache = CentralCache()
        return centralCache
    }()
    
    private let movieDetailCache = NSCache<NSNumber, Movie>()
    
    private init() { }

    // MARK: - Accessors

    public class func shared() -> CentralCache {
        return sharedInstance
    }

    func getMovieDetailCache() -> NSCache<NSNumber, Movie> {
        return movieDetailCache
    }
    
    func updateMovieDetailCache(key: NSNumber, movie : Movie) {
        self.movieDetailCache.setObject(movie, forKey: key)
    }
    
    func movieDetailFromCache(key : NSNumber) -> Movie? {
        return movieDetailCache.object(forKey: key)
    }
}
