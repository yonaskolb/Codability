import XCTest
import Foundation
@testable import Codability

final class AnyContainerTests: XCTestCase {

    let jsonString = """
        {
            "boolean": true,
            "integer": 1,
            "double": 3.2,
            "string": "string",
            "array": [1, 2, 3],
            "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            }
        }
        """

    let jsonValue: [String: Any] = [
        "boolean": true,
        "integer": 1,
        "double": 3.2,
        "string": "string",
        "array": [1, 2, 3],
        "nested": [
            "a": "alpha",
            "b": "bravo",
            "c": "charlie"
        ]
    ]

    let object = Object(boolean: true, integer: 1, double: 3.2, string: "string", array: [1,2,3])

    lazy var anyJson = """
    {
        "dictionary": \(jsonString),
        "array": [
        "hello",
        2,
        true
        ],
        "value": true
        }
    """

    func testDecoding() {
        let json = jsonString.data(using: .utf8)!

        let decoder = JSONDecoder()
        let dictionary = try! decoder.decode([String: AnyCodable].self, from: json)

        XCTAssertEqual(dictionary["boolean"]?.value as! Bool, true)
        XCTAssertEqual(dictionary["integer"]?.value as! Int, 1)
        XCTAssertEqual(dictionary["double"]?.value as! Double, 3.2)
        XCTAssertEqual(dictionary["string"]?.value as! String, "string")
        XCTAssertEqual(dictionary["array"]?.value as! [Int], [1, 2, 3])
        XCTAssertEqual(dictionary["nested"]?.value as! [String: String], ["a": "alpha", "b": "bravo", "c": "charlie"])
    }

    func testEncoding() {
        let dictionary: [String: AnyCodable] = [
            "boolean": true,
            "integer": 1,
            "double": 3.2,
            "string": "string",
            "array": [1, 2, 3],
            "nested": [
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
            ]
        ]

        let encoder = JSONEncoder()

        let json = try! encoder.encode(dictionary)
        let encodedJSONObject = try! JSONSerialization.jsonObject(with: json, options: []) as! NSDictionary

        let expected = jsonString.data(using: .utf8)!
        let expectedJSONObject = try! JSONSerialization.jsonObject(with: expected, options: []) as! NSDictionary

        XCTAssertEqual(encodedJSONObject, expectedJSONObject)
    }

    func testObjectCoding() throws {

        let json = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        let decodedObject = try! decoder.decode(Object.self, from: json)
        let encodedObject = try encoder.encode(decodedObject)
        let decodedEncodedObject = try! decoder.decode(Object.self, from: encodedObject)

        XCTAssertEqual(object, decodedObject)
        XCTAssertEqual(decodedObject, decodedEncodedObject)
    }

    func testCodingAny() throws {

        let json = anyJson.data(using: .utf8)!

        let decoder = JSONDecoder()
        let object = try decoder.decode(AnyContainer.self, from: json)

        func assert(_ object: AnyContainer) {
            XCTAssertEqual(object.dictionary["boolean"] as! Bool, true)
            XCTAssertEqual(object.dictionary["integer"] as! Int, 1)
            XCTAssertEqual(object.dictionary["double"] as! Double, 3.2)
            XCTAssertEqual(object.dictionary["string"] as! String, "string")
            XCTAssertEqual(object.dictionary["array"] as! [Int], [1, 2, 3])
            XCTAssertEqual(object.dictionary["nested"] as! [String: String], ["a": "alpha", "b": "bravo", "c": "charlie"])
            XCTAssertEqual(object.array[0] as! String, "hello")
            XCTAssertEqual(object.array[1] as! Int, 2)
            XCTAssertEqual(object.array[2] as! Bool, true)
            XCTAssertEqual(object.value as! Bool, true)
        }
        assert(object)

        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        let object2 = try decoder.decode(AnyContainer.self, from: data)
        assert(object2)
    }

    func testToDictionary() throws {
        let json = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let decodedObject = try! decoder.decode(DictionaryObject.self, from: json)
        XCTAssertTrue((decodedObject.properties as NSDictionary).isEqual(to: jsonValue))
    }


    static var allTests = [
        ("testCodingAny", testCodingAny),
        ]
}

struct DictionaryObject: Decodable {
    let properties: [String: Any]
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RawCodingKey.self)
        properties = try container.toDictionary()
    }
}

struct Object: Codable, Equatable {

    let boolean: Bool
    let integer: Int
    let double: Double
    let string: String
    let array: [Int]

    init(boolean: Bool, integer: Int, double: Double, string: String, array: [Int]) {
        self.boolean = boolean
        self.integer = integer
        self.double = double
        self.string = string
        self.array = array
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RawCodingKey.self)

        boolean = try container.decode("boolean")
        integer = try container.decode("integer")
        double = try container.decode("double")
        string = try container.decode("string")
        array = try container.decode("array")
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RawCodingKey.self)
        try container.encode(boolean, forKey: "boolean")
        try container.encode(integer, forKey: "integer")
        try container.encode(double, forKey: "double")
        try container.encode(string, forKey: "string")
        try container.encode(array, forKey: "array")
    }
}

struct AnyContainer: Codable {

    let dictionary: [String: Any]
    let array: [Any]
    let value: Any

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        dictionary = try container.decodeAny([String: Any].self, forKey: .dictionary)
        array = try container.decodeAny([Any].self, forKey: .array)
        value = try container.decodeAny(Any.self, forKey: .value)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeAny(dictionary, forKey: .dictionary)
        try container.encodeAny(array, forKey: .array)
        try container.encodeAny(value, forKey: .value)
    }

    enum CodingKeys: CodingKey {
        case dictionary
        case value
        case array
    }
}
