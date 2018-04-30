//
//  InvalidElementDecodingStrategy.swift
//  Codability
//
//  Created by Yonas Kolb on 30/4/18.
//

import Foundation

public enum InvalidElementStrategy<T>: CustomStringConvertible {
    case remove
    case fail
    case fallback(T)
    case custom((DecodingError) -> InvalidElementStrategy<T>)

    func decodeItem(onError: ((Error) -> ())? = nil, decode: () throws -> T) throws -> T? {
        do {
            return try decode()
        } catch {
            onError?(error)
            switch self {
            case .remove:
                return nil
            case .fail:
                throw error
            case let .fallback(value):
                return value
            case let .custom(getBehaviour):
                guard let decodingError = error as? DecodingError else { throw error }
                let behaviour = getBehaviour(decodingError)
                return try behaviour.decodeItem(onError: onError, decode: decode)
            }
        }
    }

    func toType<T>() -> InvalidElementStrategy<T> {
        switch self {
        case .remove:
            return .remove
        case .fail:
            return .fail
        case let .fallback(value):
            if let value = value as? T {
                return .fallback(value)
            } else {
                return .fail
            }
        case let .custom(getBehaviour):
            return .custom( { error in
                getBehaviour(error).toType()
            })
        }
    }

    public var description: String {
        switch self {
        case .remove:
            return "remove"
        case .fail:
            return "fail"
        case .fallback:
            return "fallback"
        case .custom:
            return "custom"
        }
    }
}

extension KeyedDecodingContainer {

    public func decodeArray<T: Decodable>(_ type: [T].Type, forKey key: K, invalidElementStrategy: InvalidElementStrategy<T>? = nil) throws -> [T] {
        var container = try nestedUnkeyedContainer(forKey: key)
        var chosenInvalidElementStrategy: InvalidElementStrategy<T>
        if let invalidElementStrategy = invalidElementStrategy {
            chosenInvalidElementStrategy = invalidElementStrategy
        } else if let invalidElementStrategy = try superDecoder().userInfo[.invalidElementStrategy] as? InvalidElementStrategy<Any> {
            chosenInvalidElementStrategy = invalidElementStrategy.toType()
        } else {
            chosenInvalidElementStrategy = .fail
        }

        var array: [T] = []
        while !container.isAtEnd {
            let element: T? = try chosenInvalidElementStrategy.decodeItem(onError: { _ in
                // hack to advance the current index
                _ = try? container.decode(AnyCodable.self)
            }) {
                try container.decode(T.self)
            }
            if let element = element {
                array.append(element)
            }
        }
        return array
    }

    public func decodeArrayIfPresent<T: Decodable>(_ type: [T].Type, forKey key: K, invalidElementStrategy: InvalidElementStrategy<T>? = nil) throws -> [T]? {
        if !contains(key) {
            return nil
        }
        return try decodeArray(type, forKey: key, invalidElementStrategy: invalidElementStrategy)
    }

    public func decodeDictionary<T: Decodable>(_ type: [String: T].Type, forKey key: K, invalidElementStrategy: InvalidElementStrategy<T>? = nil) throws -> [String: T] {
        let container = try self.nestedContainer(keyedBy: RawCodingKey.self, forKey: key)

        var chosenInvalidElementStrategy: InvalidElementStrategy<T>
        if let invalidElementStrategy = invalidElementStrategy {
            chosenInvalidElementStrategy = invalidElementStrategy
        } else if let invalidElementStrategy = try superDecoder().userInfo[.invalidElementStrategy] as? InvalidElementStrategy<Any> {
            chosenInvalidElementStrategy = invalidElementStrategy.toType()
        } else {
            chosenInvalidElementStrategy = .fail
        }

        var dictionary: [String: T] = [:]
        for key in container.allKeys {

            let element: T? = try chosenInvalidElementStrategy.decodeItem {
                try container.decode(T.self, forKey: key)
            }
            if let element = element {
                dictionary[key.stringValue] = element
            }
        }
        return dictionary
    }

    public func decodeDictionaryIfPresent<T: Decodable>(_ type: [String: T].Type, forKey key: K, invalidElementStrategy: InvalidElementStrategy<T>? = nil) throws -> [String: T]? {
        if !contains(key) {
            return nil
        }
        return try decodeDictionary(type, forKey: key, invalidElementStrategy: invalidElementStrategy)
    }
}

extension CodingUserInfoKey {
    static let invalidElementStrategy = CodingUserInfoKey(rawValue: "invalidElementStrategy")!
}
