//
//  Movie.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 01/06/21.
//

import Foundation

class Movie: AnyEntity {
    var adult: Bool?
    var backdrop_path: String?
    var budget: Int?
    var genres: [Genre]?
    var homepage: String?
    var imdb_id: String?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var genre_ids: [Int]?
    var id: Int?
    var popularity: Double?
    var poster_path: String?
    var production_companies: [ProductionCompany]?
    var production_countries: [ProductionCountry]?
    var release_date: String?
    var revenue: Int?
    var runtime: Int?
    var spoken_languages: [SpokenLanguage]?
    var status: MovieStatus?
    var tagline: String?
    var title: String?
    var vote_count: Int?
    var video: Bool?
    var vote_average: Double?
    
    var videos : MovieVideoList?
    
    var trailerURL : String {
        
        let trailer = videos?.results?.first(where: {$0.type == .trailer})
        var baseVideoURL = ""
        
        // This can be upgraded with an enum, but I couldn't find all the values.
        if trailer?.site == "YouTube" {
            baseVideoURL = "https://www.youtube.com/embed/"
        } else {
            return ""
        }
        
        guard let externalKey = trailer?.key else {
            return ""
        }
        
        return baseVideoURL + externalKey + "?playsinline=1"
    }
    
    private enum CodingKeys : String, CodingKey {
        case adult                  = "adult"
        case backdrop_path          = "backdrop_path"
        case budget                 = "budget"
        case genres                 = "genres"
        case homepage               = "homepage"
        case imdb_id                = "imdb_id"
        case original_language      = "original_language"
        case original_title         = "original_title"
        case overview               = "overview"
        case genre_ids              = "genre_ids"
        case id                     = "id"
        case popularity             = "popularity"
        case poster_path            = "poster_path"
        case production_companies   = "production_companies"
        case production_countries   = "production_countries"
        case release_date           = "release_date"
        case revenue                = "revenue"
        case runtime                = "runtime"
        case spoken_languages       = "spoken_languages"
        case status                 = "status"
        case tagline                = "tagline"
        case title                  = "title"
        case vote_count             = "vote_count"
        case video                  = "video"
        case vote_average           = "vote_average"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(adult, forKey: .adult)
        try container.encode(backdrop_path, forKey: .backdrop_path)
        try container.encode(budget, forKey: .budget)
        try container.encode(genres, forKey: .genres)
        try container.encode(imdb_id, forKey: .imdb_id)
        try container.encode(original_language, forKey: .original_language)
        try container.encode(original_title, forKey: .original_title)
        try container.encode(overview, forKey: .overview)
        try container.encode(genre_ids, forKey: .genre_ids)
        try container.encode(id, forKey: .id)
        try container.encode(popularity, forKey: .popularity)
        try container.encode(poster_path, forKey: .poster_path)
        try container.encode(production_companies, forKey: .production_companies)
        try container.encode(production_countries, forKey: .production_countries)
        try container.encode(release_date, forKey: .release_date)
        try container.encode(revenue, forKey: .revenue)
        try container.encode(runtime, forKey: .runtime)
        try container.encode(spoken_languages, forKey: .spoken_languages)
        try container.encode(status, forKey: .status)
        try container.encode(tagline, forKey: .tagline)
        try container.encode(title, forKey: .title)
        try container.encode(vote_count, forKey: .vote_count)
        try container.encode(video, forKey: .video)
        try container.encode(vote_average, forKey: .vote_average)
    }
}

enum MovieStatus : String, AnyEntity {
    case rumored = "Rumored"
    case planned = "Planned"
    case inProduction = "In Production"
    case postProduction = "Post Production"
    case released = "Released"
    case canceled = "Canceled"
}
