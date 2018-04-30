import Foundation

extension KeyedDecodingContainer {

    // codable
    public func decode<T>(_ key: KeyedDecodingContainer.Key) throws -> T where T: Decodable {
        return try decode(T.self, forKey: key)
    }

    public func decodeIfPresent<T>(_ key: KeyedDecodingContainer.Key) throws -> T? where T: Decodable {
        return try decodeIfPresent(T.self, forKey: key)
    }

    // any
    public func decodeAny<T>(_ key: K) throws -> T {
        return try decodeAny(T.self, forKey: key)
    }

    public func decodeAnyIfPresent<T>(_ key: K) throws -> T? {
        return try decodeAnyIfPresent(T.self, forKey: key)
    }

    // array
    public func decodeArray<T: Decodable>(_ key: K, invalidElementStrategy: InvalidElementStrategy<T>? = nil) throws -> [T] {
        return try decodeArray([T].self, forKey: key, invalidElementStrategy: invalidElementStrategy)
    }

    public func decodeArrayIfPresent<T: Decodable>(_ key: K, invalidElementStrategy: InvalidElementStrategy<T>? = nil) throws -> [T]? {
        return try decodeArrayIfPresent([T].self, forKey: key, invalidElementStrategy: invalidElementStrategy)
    }

    // dictionary
    public func decodeDictionary<T: Decodable>(_ key: K, invalidElementStrategy: InvalidElementStrategy<T>? = nil) throws -> [String: T] {
        return try decodeDictionary([String: T].self, forKey: key, invalidElementStrategy: invalidElementStrategy)
    }

    public func decodeDictionaryIfPresent<T: Decodable>(_ key: K, invalidElementStrategy: InvalidElementStrategy<T>? = nil) throws -> [String: T]? {
        return try decodeDictionaryIfPresent([String: T].self, forKey: key, invalidElementStrategy: invalidElementStrategy)
    }
}

extension UnkeyedDecodingContainer {

    mutating func decode<T: Decodable>() throws -> T {
        return try decode(T.self)
    }

    mutating func decodeIfPresent<T: Decodable>() throws -> T? {
        return try decodeIfPresent(T.self)
    }
}
