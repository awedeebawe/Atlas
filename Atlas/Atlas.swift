/*
* Copyright (c) 2016 RentPath, LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

public class Atlas {
    
    private var _json: JSON?
    private var _jsonArray: [JSON]?
    private var _jsonObject: [String: JSON]?
    private var _key: String?
    private var _keyIsOptional = false
    private var _forceTo = false
    
    /**
     
     Designated initializer that accepts JSON
     
     - Parameters json: JSON
     
     */
    required public init(_ json: JSON) throws {
        switch json {
        case let o as [String: AnyObject]:
            _jsonObject = o.cleaned()
        case let a as [AnyObject]:
            _jsonArray = a
        default:
            // Any individual object, String, Int, Bool, etc...
            _json = json
        }
    }
    
    /**
     
     Accepts the key name you would like to map to model field
     
     - Parameters key: The string that represents the key in the JSON object.
     
     - Throws: Can throw a `MappingError` if `key` doesn't exist in `fromJSON`
     
     - Returns: RPMapper object for a fluent interface
     
     */
    public func mapKey(key: String) throws -> Self {
        _keyIsOptional = false
        _key = key
        return self
    }

    
    public func mapKey<T: AtlasMap>(key: String) throws -> T? {
        _keyIsOptional = false
        _key = key
        do {
            return try to()
        } catch {
            throw error
        }
    }
    
    public func mapOptionalKey(key: String) throws -> Self {
        _keyIsOptional = true
        _key = key
        return self
    }
    
    public func mapOptionalKey<T: AtlasMap>(key: String) throws -> T? {
        _keyIsOptional = true
        _key = key
        do {
            return try to()
        } catch {
            throw error
        }
    }
    
    public func map<T: AtlasMap>() throws -> T? {
        _keyIsOptional = false
        _key = nil
        do {
            return try to()
        } catch {
            throw error
        }
    }
    
    public func mapArrayFromKey<T: AtlasMap>(key: String) throws -> [T]? {
        _keyIsOptional = false
        _key = key
        do {
            return try toArrayOf()
        } catch {
            throw error
        }
    }
    
    public func mapArrayFromOptionalKey<T: AtlasMap>(key: String) throws -> [T]? {
        _keyIsOptional = true
        _key = key
        do {
            return try toArrayOf()
        } catch {
            throw error
        }
    }
    
    public func mapArray<T: AtlasMap>() throws -> [T]? {
        _keyIsOptional = false
        _key = nil
        do {
            return try toArrayOf()
        } catch {
            throw error
        }
    }
    
    /**
     
     Used to map `key` to the type specified when calling `-to:` or `forceTo:`. If the key does not exist no `MappingError` will be thrown.
     
     - Parameters key: The string that represents the key in the JSON object.

     - Returns: RPMapper object for a fluent interface
     
     */
//    public func fromOptionalKey<T>(key: String) throws -> T? {
//        _keyIsOptional = true
//        _key = key
//        do {
//            return try to()
//        } catch {
//            throw error
//        }
//    }
    
    /**
    
     Used to forecully map an object to type `T`. Ex. Say you have a JSON object with a KVP of {"phone": "5552325656"}. You could "forcefully" map the value to type "Int" using `map.("phone").forceTo(Int)`. This would attempt to map the string "5552325656" to a true Int value of 5552325656.
     
     - Parameters type: Type you would like the JSON value to be converted to
     
     - Throws: If `-key:` method was used, a `MappingError` may be thrown if the type cannot be converted or key does not exists
     
     - Returns: An Optional `T`
     
     */
//    public func forceTo<T>() throws -> T? {
//        _forceTo = true
//        let result: T?
//        do {
//             result = try to()
//        } catch {
//            throw error
//        }
//        
//        _forceTo = false
//        return result
//    }
    
    /**
     
     A type you would like the JSON value to be converted, this could be a 'primitive' or a model type
     
     - Parameters type: Type you would like the JSON value to be converted to
     
     - Throws: If `-key:` method was used, a `MappingError` may be thrown if the type cannot be converted or key does not exists
     
     - Returns: An Optional `T`
     
     */
    private func to<T: AtlasMap>() throws -> T? {
//        switch _json {
//        case is [String: AnyObject]:
            var jsonObject: JSON?
            
            if let __key = _key {
                if let _jsonObject = _jsonObject?[__key] {
                    jsonObject = _jsonObject
                }
                
                if jsonObject == nil && !_keyIsOptional {
                    throw MappingError.KeyNotInJSONError("Mapping to \(T.self) failed. \(__key) is not in the JSON object provided.")
                }
            } else {
                jsonObject = _jsonObject
            }
            
            guard let unwrappedVal = jsonObject else {
                if _keyIsOptional {
                    return nil
                } else {
                    throw MappingError.GenericMappingError
                }
            }

//            _val = unwrappedVal
//        default:
//            _val = _json
//        }
        
        guard let mappedObject = try T.init(json: unwrappedVal) else {
            throw MappingError.NotMappable(".\(_key ?? "NoKey") - Unable to map \(jsonObject) to type \(T.self)")
        }
        
        return mappedObject
    }
    
    /**
     
     A array of type you would like the JSON array value to be converted, this could be a 'primitive' or a model type
     
     - Parameters type: Type you would like the JSON array value to be converted
     
     - Throws: If `-key:` method was used, a `MappingError` may be thrown if the type cannot be converted or key does not exists
     
     - Returns: An Optional array of `T`
     
     */
    private func toArrayOf<T: AtlasMap>() throws -> [T]? {
        var jsonArray: [JSON]? = _jsonArray

        if let __key = _key {
            if let _jsonArray = _jsonObject?[__key] {
                jsonArray = _jsonArray as? [JSON]
            }
            
            if jsonArray == nil && !_keyIsOptional {
                throw MappingError.KeyNotInJSONError("While trying to map the value of \(__key) in the provided JSON to type \(T.self), we found that the key is not isn the JSON object provided.")
            }
        }

        guard let unwrappedArray = jsonArray else {
            if _keyIsOptional {
                return nil
            } else {
                throw MappingError.NotAnArray
            }
        }

        var array = [T]()
        for obj in unwrappedArray {
            guard let mappedObj: T = try T.init(json: obj) else {
                throw MappingError.NotMappable(".\(_key ?? "NoKey") - Unable to map \(jsonArray) to type \(T.self)")
            }
            
            array.append(mappedObj)
        }
        
        return array
    }
    
    /**
     
     Map a RFC3339 date from JSON to Model field
     
     - Throws: If `Key` method was not used a `MappingError` may be thrown, also a `MappingError` will be thrown if the value is not a string type
     
     - Returns: An Optional NSDate
     
     */
    public func toRFC3339Date() throws -> NSDate? {
        
        return try toDate("yyyy-MM-dd'T'HH:mm:ss.S'Z'")
    }
    
    /**
     
     Map a date from JSON to Model field with a given date format string
     
     - Parameters format: string representation of the date format
     
     - Throws: If `Key` method was not used an `MappingError` may be thrown, also a `MappingError` will be thrown if the value is not a string type
     
     - Returns: An Optional NSDate
     
     */
    public func toDate(format: String) throws -> NSDate? {
        guard let key = _key else {
            if _keyIsOptional {
                return nil
            } else {
                throw MappingError.NoKeyError
            }
        }
        
        guard let _val = _jsonObject?[key] as? String where !_val.isEmpty else {

            if _keyIsOptional {
                return nil
            } else {
                throw MappingError.NotMappable("The value of key \(key) in the provided JSON object isn't a String and therefore cannot be mapped to an NSDate.")
            }
        }
        
        guard let date = NSDate.dateFromString(_val, withFormat: format) else {
            throw MappingError.NotMappable("The date string \(_val) of key \(key) in the provided JSON object does not match the format \(format)")
        }
        
        return date
    }
    
}

extension String: AtlasMap {
    
    public func toJSON() -> JSON? {
        return nil
    }
    
    public init?(json: JSON) {
        self = String(json)
    }
    
}

extension Int: AtlasMap {
    
    public func toJSON() -> JSON? {
        return nil
    }
    
    public init?(json: JSON) {
        self = Int("\(json)")!
    }
    
}

extension Double: AtlasMap {
    
    public func toJSON() -> JSON? {
        return nil
    }
    
    public init?(json: JSON) {
        self = Double("\(json)")!
    }
    
}

extension Float: AtlasMap {
    
    public func toJSON() -> JSON? {
        return nil
    }
    
    public init?(json: JSON) {
        self = Float("\(json)")!
    }
    
}

extension Bool: AtlasMap {
    
    public func toJSON() -> JSON? {
        return nil
    }
    
    public init?(json: JSON) {
        self = json as! Bool
    }
    
}

