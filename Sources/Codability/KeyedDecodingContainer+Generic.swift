import Foundation

extension KeyedDecodingContainer {

    public func decode<T>(_ key: KeyedDecodingContainer.Key) throws -> T where T: Decodable {
        return try decode(T.self, forKey: key)
    }

    public func decodeIfPresent<T>(_ key: KeyedDecodingContainer.Key) throws -> T? where T: Decodable {
        return try decodeIfPresent(T.self, forKey: key)
    }

    public func decodeAny<T>(_ key: K) throws -> T {
        return try decodeAny(T.self, forKey: key)
    }

    public func decodeAnyIfPresent<T>(_ key: K) throws -> T? {
        return try decodeAnyIfPresent(T.self, forKey: key)
    }

    public func decodeArray<T: Decodable>(_ key: K, invalidElementStrategy: InvalidElementStrategy<T>? = nil) throws -> [T] {
        return try decodeArray([T].self, forKey: key, invalidElementStrategy: invalidElementStrategy)
    }

    public func decodeDictionary<T: Decodable>(_ key: K, invalidElementStrategy: InvalidElementStrategy<T>? = nil) throws -> [String: T] {
        return try decodeDictionary([String: T].self, forKey: key, invalidElementStrategy: invalidElementStrategy)
    }
}
