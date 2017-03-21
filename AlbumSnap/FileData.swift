//
//  FileData.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/18/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import Foundation

struct FileData {
    let id          : String
    let secret      : String
    let name        : String
    let contentType : String
    let size        : Int
    let url         : URL
}

extension FileData {
    init?(dict: Dictionary<String, Any>?) {
        guard
            let dict        = dict,
            let id          = dict["id"] as? String,
            let secret      = dict["secret"] as? String,
            let name        = dict["name"] as? String,
            let contentType = dict["contentType"] as? String,
            let size        = dict["size"] as? Int,
            let urlString   = dict["url"]  as? String,
            let url         = URL(string: urlString)
        else { return nil }
        self.id             = id
        self.secret         = secret
        self.name           = name
        self.contentType    = contentType
        self.size           = size
        self.url            = url
    }
}
