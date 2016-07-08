//
//  Address.swift
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

struct Address {
    
    let number: Int?
    let street: String?
    let city: String?
    let state: String?
    let zip: String?
    
}

extension Address: AtlasMap {
    
    func toJSON() -> [String : AnyObject]? {
        return nil
    }
    
    init?(json: JSON) throws {
        do {
            let map = try Atlas(json)
            number = try map.key("number").to(Int)
            street = try map.key("street").to(String)
            city = try map.key("city").to(String)
            state = try map.key("state").to(String)
            zip = try map.key("zip").to(String)
        } catch let e {
            throw e
        }
    }
}
