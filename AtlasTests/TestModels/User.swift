//
//  User.swift
//  Atlas
//
//  Created by Jeremy Fox on 3/30/16.
//  Copyright © 2016 RentPath. All rights reserved.
//

import Foundation

#if os(tvOS)
    import AtlasTV
#else
    import Atlas
#endif
    
struct User {
    
    let firstName: String?
    let lastName: String?
    let email: String
    let phone: Int?
    let avatarURL: String?
    let isActive: Bool
    let memberSince: NSDate?
    let address: Address?
    let photos: [Photo]?
    let floorPlans: []
    
}

extension User: AtlasMap {
    
    func toJSON() -> [String : AnyObject]? {
        return nil
    }
    
    init?(json: JSON) throws {
        do {
            let map = try Atlas(json)
            firstName = try map.key("first_name").to(String)
            lastName = try map.key("last_name").to(String)
            email = try map.key("email").to(String) ?? ""
            phone = try map.key("phone").to(Int)
            avatarURL = try map.key("avatar").to(String)
            isActive = try map.key("is_active").to(Bool) ?? false
            memberSince = try map.key("member_since").toRFC3339Date()
        } catch let e {
            throw e
        }
    }
    
}


//////////////////////////////////


struct UserNoKey {
    
    let firstName: String?
    let lastName: String?
    let email: String
    let phone: Int?
    let avatarURL: String?
    let isActive: Bool
    let memberSince: NSDate?
    
}

extension UserNoKey: AtlasMap {
    
    func toJSON() -> [String : AnyObject]? {
        return nil
    }
    
    init?(json: JSON) throws {
        do {
            let map = try Atlas(json)
            firstName = try map.key("first_name").to(String)
            lastName = try map.to(String) // Not calling .key("last_name") purposely for a test
            email = try map.key("email").to(String) ?? ""
            phone = try map.key("phone").to(Int)
            avatarURL = try map.key("avatar").to(String)
            isActive = try map.key("is_active").to(Bool) ?? false
            memberSince = try map.key("member_since").toRFC3339Date()
        } catch let e {
            throw e
        }
    }
    
}
