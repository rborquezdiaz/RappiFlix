//
//  MovieVideo.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 04/06/21.
//

import Foundation

class MovieVideo : AnyEntity {
    var id: String?
    var iso_639_1 : String?
    var iso_3166_1 : String?
    var key : String?
    var name: String?
    var site : String?
    var size : Int?
    var type : MovieVideoType?
    
}

enum MovieVideoType : String, AnyEntity {
    case trailer = "Trailer"
    case teaser = "Teaser"
    case clip = "Clip"
    case featurette = "Featurette"
    case behindTheScenes = "Behind the Scenes"
    case bloopers = "Bloopers"
}
