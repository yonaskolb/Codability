import Foundation

extension KeyedDecodingContainer {

    public func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        guard let value = try decode(AnyCodable.self, forKey: key).value as? [String: Any] else {
            throw DecodingError.typeMismatch([String: Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Decoding of [String: Any] failed"))
        }
        return value
    }

    public func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        guard let value = try decode(AnyCodable.self, forKey: key).value as? [Any] else {
            throw DecodingError.typeMismatch([Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Decoding of [Any] failed"))
        }
        return value
    }

    public func decode(_ type: Any.Type, forKey key: K) throws -> Any {
        return try decode(AnyCodable.self, forKey: key).value
    }

    public func decodeIfPresent(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any]? {
        guard let possibleValue = try decodeIfPresent(AnyCodable.self, forKey: key) else { return nil }

        guard let value = possibleValue.value as? [String: Any] else {
            throw DecodingError.typeMismatch([String: Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Decoding of [String: Any] failed"))
        }
        return value
    }

    public func decodeIfPresent(_ type: [Any].Type, forKey key: K) throws -> [Any]? {
        guard let possibleValue = try decodeIfPresent(AnyCodable.self, forKey: key) else { return nil }

        guard let value = possibleValue.value as? [Any] else {
            throw DecodingError.typeMismatch([Any].self, DecodingError.Context(codingPath: codingPath, debugDescription: "Decoding of [Any] failed"))
        }
        return value
    }

}
