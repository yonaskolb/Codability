import Foundation

/// Discriminator key enum used to retrieve discriminator fields in JSON payloads.
public enum Discriminator: String, CodingKey {
    case type = "type"
    case modelType = "modelType"
    case code = "code"
}

/// To support a new class family, create an enum that conforms to this protocol and contains the different types.
public protocol ClassFamily: Decodable {
    /// The discriminator key.
    static var discriminator: Discriminator { get }

    associatedtype BaseType: Decodable

    /// Returns the class type of the object coresponding to the value.
    func getType() -> BaseType.Type
}

extension KeyedDecodingContainer {

    // codable
    public func decode<T>(_ key: KeyedDecodingContainer.Key) throws -> T where T: Decodable {
        return try decode(T.self, forKey: key)
    }

    public func decodeIfPresent<T>(_ key: KeyedDecodingContainer.Key) throws -> T? where T: Decodable {
        return try decodeIfPresent(T.self, forKey: key)
    }

    /// Decode a heterogeneous list of objects for a given family.
    /// - Parameters:
    ///     - heterogeneousType: The decodable type of the list.
    ///     - family: The ClassFamily enum for the type family.
    ///     - key: The CodingKey to look up the list in the current container.
    /// - Returns: The resulting list of heterogeneousType elements.
    public func decode<F : ClassFamily>(family: F.Type, forKey key: K) throws -> [F.BaseType] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        var list = [F.BaseType]()
        var tmpContainer = container

        while !container.isAtEnd {
            let typeContainer = try container.nestedContainer(keyedBy: Discriminator.self)
            let family = try typeContainer.decode(F.self, forKey: F.discriminator)
            let type = family.getType()
            list.append(try tmpContainer.decode(type))
        }
        return list
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
