
import Foundation

public struct RawCodingKey: CodingKey {

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
}

extension RawCodingKey: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {

    public init(stringLiteral value: String) {
        string = value
        int = nil
    }

    public init(integerLiteral value: Int) {
        string = ""
        int = value
    }
}
