import XCTest
import Foundation
@testable import Codability

final class HeterogeneousDecodingTests: XCTestCase {

	let heterogenousJson = """
	{
	    "drinks": [
	        {
	            "type": "drink",
	            "description": "All natural"
	        },
	        {
	            "type": "beer",
	            "description": "best drunk on fridays after work",
	            "alcohol_content": "5%"
	        }
	    ]
	}
	"""
	
	func testDecodingHeterogenousJson() throws {
        let bar = try! JSONDecoder().decode(Bar.self, from: heterogenousJson.data(using: .utf8)!)
		
		XCTAssertTrue(bar.drinks.count > 0)
		XCTAssertEqual(bar.drinks[0].description, "All natural")
		XCTAssertEqual((bar.drinks[1] as! Beer).description, "best drunk on fridays after work")
		XCTAssertEqual((bar.drinks[1] as! Beer).alcohol_content, "5%")
	}
}


class Drink: Decodable {
    var type: String
    var description: String
	
    private enum CodingKeys: String, CodingKey {
        case type
        case description
    }
}

class Beer: Drink {
    var alcohol_content: String

    private enum CodingKeys: String, CodingKey {
        case alcohol_content
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.alcohol_content = try container.decode(String.self, forKey: .alcohol_content)
        try super.init(from: decoder)
    }
}

class Bar: Decodable {
	let drinks: [Drink]
	
    private enum CodingKeys: String, CodingKey {
        case drinks
    }
	
	enum DrinkFamily: String, ClassFamily {
	    case drink = "drink"
	    case beer = "beer"

	    static var discriminator: Discriminator = .type

        typealias BaseType = Drink

	    func getType() -> Drink.Type {
	        switch self {
	        case .beer:
	            return Beer.self
			case .drink:
	            return Drink.self
	        }
	    }
	}
	
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        drinks = try container.decode(family: DrinkFamily.self, forKey: .drinks)
    }
}
