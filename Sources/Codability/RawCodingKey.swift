
import Foundation

public struct RawCodingKey: CodingKey, ExpressibleByStringLiteral {

    private let string: String
    private let int: Int?

    public var stringValue: String { return string }

    public init(string: String) {
        self.string = string
        int = nil
    }
    public init?(stringValue: String) {
        string = stringValue
        int = nil
    }

    public var intValue: Int? { return int }
    public init?(intValue: Int) {
        string = String(describing: intValue)
        int = intValue
    }

    public init(stringLiteral value: String) {
        string = value
        int = nil
    }
}
