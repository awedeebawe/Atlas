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
    
    var _executor: AtlasMapExector!
    var _jsonArray: [JSON]? {
        get {
            return _executor.jsonArray
        }
        set {
            _executor.jsonArray = newValue
        }
    }
    var _jsonObject: [String: JSON]? {
        get {
            return _executor.jsonObject
        }
        set {
            _executor.jsonObject = newValue
        }
    }
    var _key: String? {
        get {
            return _executor.key
        }
        set {
            _executor.key = newValue
        }
    }
    var _keyIsOptional: Bool {
        get {
            return _executor.keyIsOptional
        }
        set {
            _executor.keyIsOptional = newValue
        }
    }
    
    /**
     Designated initializer that accepts JSON
     
     - Parameter json: A JSON object/array. Use NSJSONSerialization to get the JSON object/array from NSData and then pass the value into Atlas.
     */
    required public init(_ json: JSON, executor: AtlasMapExector? = nil) throws {
        _executor = executor ?? AtlasMappingExecutor()
        switch json {
        case let o as [String: AnyObject]:
            _jsonObject = o.cleaned()
        case let a as [AnyObject]:
            _jsonArray = a
        default:
            throw MappingError.NotAJSONObjectError
        }
    }
    
    /////////////////////////////////////////////////////
    //MARK: Top level object mapping - key not required
    /////////////////////////////////////////////////////
    
    public func map<T: AtlasMap>() throws -> T? {
        _keyIsOptional = false
        _key = nil
        do {
            return try _executor.executeObjectMapping()
        } catch {
            throw error
        }
    }
    
    public func mapArray<T: AtlasMap>() throws -> [T]? {
        _keyIsOptional = false
        _key = nil
        do {
            return try _executor.executeArrayMapping()
        } catch {
            throw error
        }
    }
    
    /////////////////////////////////////////////////////
    //MARK: Required Sub-object mapping - key required
    /////////////////////////////////////////////////////
    
    /**
     Used to map the value of `key` to an instance of `T`
     
     - Parameter key: A string that represents the key in the JSON object.
     
     - Throws: Can throw a `MappingError` if `key` doesn't exist in the JSON
     
     - Returns: An instance of `T`
     */
    public func mapKey<T: AtlasMap>(key: String) throws -> T? {
        _keyIsOptional = false
        _key = key
        do {
            return try _executor.executeObjectMapping()
        } catch {
            throw error
        }
    }
    
    
    public func mapArrayFromKey<T: AtlasMap>(key: String) throws -> [T]? {
        _keyIsOptional = false
        _key = key
        do {
            return try _executor.executeArrayMapping()
        } catch {
            throw error
        }
    }
    
    /////////////////////////////////////////////////////
    //MARK: Optional Sub-object mapping - key required
    /////////////////////////////////////////////////////
    
    /**
     Used to optionally map the value of `key` to an instance of `T`. If `key` doesn't exist in JSON, mapping execution will continue without an error being thrown.
     
     - Parameter key: A string that represents the key in the JSON object.
     
     - Throws: Can throw a `MappingError` if unable to mapp the value of `key` to type `T`
     
     - Returns: An instance of `T`
     */
    public func mapOptionalKey<T: AtlasMap>(key: String) throws -> T? {
        _keyIsOptional = true
        _key = key
        do {
            return try _executor.executeObjectMapping()
        } catch {
            throw error
        }
    }
    
    public func mapArrayFromOptionalKey<T: AtlasMap>(key: String) throws -> [T]? {
        _keyIsOptional = true
        _key = key
        do {
            return try _executor.executeArrayMapping()
        } catch {
            throw error
        }
    }
    
}

