//
//  InvalidElementTests.swift
//  CodabilityTests
//
//  Created by Yonas Kolb on 30/4/18.
//

import XCTest
import Foundation
@testable import Codability

final class InvalidElementTests: XCTestCase {

    let json = """
        {
            "array": [1, "two", 3],
            "dictionary": {
                "one": 1,
                "two": "two",
                "three": 3
            }
        }
        """.data(using: .utf8)!

    struct DefaultStrategyObject: Decodable {

        let array: [Int]
        let dictionary: [String: Int]

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: RawCodingKey.self)
            array = try container.decodeArray([Int].self, forKey: "array")
            dictionary = try container.decodeDictionary([String: Int].self, forKey: "dictionary")
        }
    }

    struct ExplicitStrategyObject: Decodable {

        let array: [Int]
        let dictionary: [String: Int]

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: RawCodingKey.self)
            array = try container.decodeArray([Int].self, forKey: "array", invalidElementStrategy: .remove)
            dictionary = try container.decodeDictionary([String: Int].self, forKey: "dictionary", invalidElementStrategy: .remove)
        }
    }

    func testDefaultInvalidElementStrategy() throws {

        let decoder = JSONDecoder()

        decoder.userInfo[.invalidElementStrategy] = InvalidElementStrategy<Any>.remove
        let decodedObject = try decoder.decode(DefaultStrategyObject.self, from: json)
        XCTAssertEqual(decodedObject.array, [1, 3])
        XCTAssertEqual(decodedObject.dictionary, ["one": 1, "three": 3])

        decoder.userInfo[.invalidElementStrategy] = InvalidElementStrategy<Any>.fallback(2)
        let decodedObject2 = try decoder.decode(DefaultStrategyObject.self, from: json)
        XCTAssertEqual(decodedObject2.array, [1, 2, 3])
        XCTAssertEqual(decodedObject2.dictionary, ["one": 1, "two": 2, "three": 3])

        decoder.userInfo[.invalidElementStrategy] = InvalidElementStrategy<Any>.fail
        XCTAssertThrowsError(_ = try decoder.decode(DefaultStrategyObject.self, from: json))

        decoder.userInfo[.invalidElementStrategy] = InvalidElementStrategy<Any>.custom({ _ in .remove })
        let decodedObject3 = try decoder.decode(DefaultStrategyObject.self, from: json)
        XCTAssertEqual(decodedObject3.array, [1, 3])
        XCTAssertEqual(decodedObject3.dictionary, ["one": 1, "three": 3])
    }

    func testExplictInvalidElementStrategy() throws {

        let decoder = JSONDecoder()

        let decodedObject = try decoder.decode(ExplicitStrategyObject.self, from: json)
        XCTAssertEqual(decodedObject.array, [1, 3])
        XCTAssertEqual(decodedObject.dictionary, ["one": 1, "three": 3])
    }
}
