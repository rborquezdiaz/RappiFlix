//
//  MovieList.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 04/06/21.
//

import Foundation

class MovieList: AnyEntity {
    var type : MovieListType = .generic
    var page: Int?
    var results: [Movie]?
    var total_results: Int?
    var total_pages: Int?
    
    private enum CodingKeys : String, CodingKey {
        case page               = "page"
        case results            = "results"
        case total_results      = "total_results"
        case total_pages        = "total_pages"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
        try container.encode(results, forKey: .results)
        try container.encode(total_results, forKey: .total_results)
        try container.encode(total_pages, forKey: .total_pages)
    }
}

enum MovieListType : String, AnyEntity {
    case popular
    case topRated
    case upcoming
    case generic
}
