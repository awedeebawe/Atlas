//
//  FloorPlan.swift
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

struct FloorPlan {
    
    let name: String?
    let photo: Photo?
    let sqft: Int?
    let beds: Int?
    let baths: Int?
    
}

extension FloorPlan: AtlasMap {
    
    func toJSON() -> [String : AnyObject]? {
        return nil
    }
    
    init?(json: JSON) throws {
        do {
            let map = try Atlas(json)
            name = try map.key("name").to(String)
            photo = try map.key("photo").to(Photo)
        } catch let e {
            throw e
        }
    }
}

