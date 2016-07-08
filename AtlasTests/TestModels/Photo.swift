//
//  Photo.swift
//  Atlas
//
//  Created by Jeremy Fox on 7/7/16.
//  Copyright © 2016 RentPath. All rights reserved.
//

import Foundation

#if os(tvOS)
    import AtlasTV
#else
    import Atlas
#endif

struct Photo {
    
    let abstract: String?
    let urlString: String?
    
}

extension Photo: AtlasMap {
    
    func toJSON() -> [String : AnyObject]? {
        return nil
    }
    
    init?(json: JSON) throws {
        do {
            let map = try Atlas(json)
            abstract = try map.key("abstract").to(String)
            urlString = try map.key("url").to(String)
        } catch let e {
            throw e
        }
    }
}
