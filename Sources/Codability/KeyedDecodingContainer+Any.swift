import Foundation

extension KeyedDecodingContainer {

    public func decodeAny<T>(_ type: T.Type, forKey key: K) throws -> T {
        guard let value = try decode(AnyCodable.self, forKey: key).value as? T else {
            throw DecodingError.typeMismatch(T.self, DecodingError.Context(codingPath: codingPath, debugDescription: "Decoding of \(T.self) failed"))
        }
        return value
    }

    public func decodeAnyIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? {
        if !contains(key) {
            return nil
        }
        
        return try decodeAny(type, forKey: key)
    }

    public func toDictionary() throws -> [String: Any] {
        var dictionary: [String: Any] = [:]
        for key in allKeys {
            dictionary[key.stringValue] = try decodeAny(key)
        }
        return dictionary
    }
}
