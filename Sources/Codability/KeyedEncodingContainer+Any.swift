
import Foundation

extension KeyedEncodingContainer {

    public mutating func encodeAnyIfPresent<T>(_ value: T?, forKey key: K) throws {
        guard let value = value else { return }
        try encodeIfPresent(AnyCodable(value), forKey: key)
    }

    public mutating func encodeAny<T>(_ value: T, forKey key: K) throws {
        try encode(AnyCodable(value), forKey: key)
    }
}
