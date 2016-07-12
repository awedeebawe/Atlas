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
    let floorPlans: [FloorPlan]?
    
}

extension User: AtlasMap {
    
    func toJSON() -> JSON? {
        return nil
    }
    
    init?(json: JSON) throws {
        do {
            let map = try Atlas(json)
            firstName = try map.mapKey("first_name")
            lastName = try map.mapKey("last_name")
            email = try map.mapKey("email")!
            phone = try map.mapKey("phone")
            avatarURL = try map.mapKey("avatar")
            isActive = try map.mapKey("is_active")!
            memberSince = nil
//            memberSince = try map.mapKey("member_since").toRFC3339Date()
            address = try map.mapKey("address")
            photos = try map.mapArrayFromKey("photos")
            floorPlans = try map.mapArrayFromKey("floorplans")
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
    
    func toJSON() -> JSON? {
        return nil
    }
    
    init?(json: JSON) throws {
        do {
            let map = try Atlas(json)
            firstName = try map.mapKey("first_name")
            lastName = try map.mapKey("foo") // foo is not a valid key in user json, this is for a test
            email = try map.mapKey("email")!
            phone = try map.mapKey("phone")
            avatarURL = try map.mapKey("avatar")
            isActive = try map.mapKey("is_active")!
            memberSince = nil
//            memberSince = try map.mapKey("member_since").toRFC3339Date()
        } catch let e {
            throw e
        }
    }
    
}
