//
//  KeyedDecodingContainer+Generic.swift
//  Codability
//
//  Created by Yonas Kolb on 25/4/18.
//

import Foundation


extension KeyedDecodingContainer {

    public func decode<T>(_ key: KeyedDecodingContainer.Key) throws -> T where T: Decodable {
        return try decode(T.self, forKey: key)
    }

    public func decodeIfPresent<T>(_ key: KeyedDecodingContainer.Key) throws -> T? where T: Decodable {
        return try decodeIfPresent(T.self, forKey: key)
    }
}
