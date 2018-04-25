
import Foundation

extension KeyedEncodingContainer {

    public mutating func encodeIfPresent(_ value: [String: Any]?, forKey key: K) throws {
        try encodeIfPresent(AnyCodable(value), forKey: key)
    }

    public mutating func encodeIfPresent(_ value: [Any]?, forKey key: K) throws {
        try encodeIfPresent(AnyCodable(value), forKey: key)
    }

    public mutating func encodeIfPresent(_ value: Any?, forKey key: K) throws {
        try encodeIfPresent(AnyCodable(value), forKey: key)
    }

    public mutating func encode(_ value: [String: Any], forKey key: K) throws {
        try encodeIfPresent(AnyCodable(value), forKey: key)
    }

    public mutating func encode(_ value: [Any], forKey key: K) throws {
        try encode(AnyCodable(value), forKey: key)
    }

    public mutating func encode(_ value: Any, forKey key: K) throws {
        try encode(AnyCodable(value), forKey: key)
    }
}
