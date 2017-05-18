//
//  Movie.swift
//  Hiep_MovieDB_NowPlaying
//
//  Created by cntt17 on 5/13/17.
//  Copyright © 2017 cntt17. All rights reserved.
//

import Foundation

class Movie {           // Khai báo các biến cần dùng 
    var id: Int?
    var title: String?
    var poster: String?
    var overview: String?
    var releaseDate: String?
    var adult: String?
    var genre_ids: String?
    var original_language: String?
    var popularity: String?
    var vote: String?
    
    init(id: Int?, title: String?, poster: String?, overview: String?, releaseDate: String?, adult: String?, genre_ids: String?, original_language: String?, popularity: String?, vote: String?) {
        self.id = id
        self.title = title
        self .poster = poster
        self.overview = overview
        self.releaseDate = releaseDate
        self.adult = adult
        self.genre_ids = genre_ids
        self.original_language = original_language
        self.popularity = popularity
        self.vote = vote
}
}
