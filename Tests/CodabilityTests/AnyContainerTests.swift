import XCTest
@testable import Codability

final class AnyContainerTests: XCTestCase {
    func testCodingAny() throws {

        let json = """
        {
        "dictionary":
            {
                "boolean": true,
                "integer": 1,
                "double": 3.14159265358979323846,
                "string": "string",
                "array": [1, 2, 3],
                "nested": {
                "a": "alpha",
                "b": "bravo",
                "c": "charlie"
                }
            },
        "array": [
            "hello",
            2,
            true
        ],
        "value": true
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let object = try decoder.decode(Object.self, from: json)

        func assert(_ object: Object) {
            XCTAssertEqual(object.dictionary["boolean"] as! Bool, true)
            XCTAssertEqual(object.dictionary["integer"] as! Int, 1)
            XCTAssertEqual(object.dictionary["double"] as! Double, 3.14159265358979323846, accuracy: 0.001)
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
        let object2 = try decoder.decode(Object.self, from: data)
        assert(object2)
    }

    static var allTests = [
        ("testCodingAny", testCodingAny),
        ]
}

struct Object: Codable {

    let dictionary: [String: Any]
    let array: [Any]
    let value: Any

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        dictionary = try container.decode([String: Any].self, forKey: .dictionary)
        array = try container.decode([Any].self, forKey: .array)
        value = try container.decode(Any.self, forKey: .value)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dictionary, forKey: .dictionary)
        try container.encode(array, forKey: .array)
        try container.encode(value, forKey: .value)
    }

    enum CodingKeys: CodingKey {
        case dictionary
        case value
        case array
    }
}
