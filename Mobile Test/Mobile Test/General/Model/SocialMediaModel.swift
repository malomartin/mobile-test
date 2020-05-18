//
//  SocialMediaModel.swift
//  Mobile Test
//
//  Created by Martin Malo on 2020-05-12.
//  Copyright © 2020 Martin Malo. All rights reserved.
//

import Foundation

struct SocialMedia: Decodable {
    
    let youtubeUrls: [URL]?
    let twitterUrls: [URL]?
    let facebookUrls: [URL]?
    
    enum CodingKeys: String, CodingKey {
        case youtubeUrls = "youtubeChannel"
        case twitter = "twitter"
        case facebookUrls = "facebook"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let youtubeUrlStrings = try values.decodeIfPresent([String].self, forKey: .youtubeUrls)
        self.youtubeUrls = youtubeUrlStrings?.compactMap({ URL(string: $0) })
        
        let twitterUrlsStrings = try values.decodeIfPresent([String].self, forKey: .twitter)
        self.twitterUrls = twitterUrlsStrings?.compactMap({ URL(string: $0) })
        
        let facebookUrlStrings = try values.decodeIfPresent([String].self, forKey: .facebookUrls)
        self.facebookUrls = facebookUrlStrings?.compactMap({ URL(string: $0) })
    }
}
