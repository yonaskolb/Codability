# Codability

[![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=for-the-badge)](https://swift.org/package-manager)
[![Git Version](https://img.shields.io/github/release/yonaskolb/Codability.svg?style=for-the-badge)](https://github.com/yonaskolb/Codability/releases)
[![Build Status](https://img.shields.io/circleci/project/github/yonaskolb/Codability.svg?style=for-the-badge)](https://circleci.com/gh/yonaskolb/Codability)
[![license](https://img.shields.io/github/license/yonaskolb/Codability.svg?style=for-the-badge)](https://github.com/yonaskolb/Codability/blob/master/LICENSE)

Useful helpers for working with `Codable` types in Swift

- [Invalid Element Strategy](#invalid-element-strategy)
- [Any Codable](#any-codable)
- [Raw CodingKey](#raw-codingkey)
- [Generic Decoding Functions](#generic-decoding-functions)

## Installing

### Swift Package Manager

Add the following to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/yonaskolb/Codability.git", from: "0.2.0"),
```

And then import wherever needed: `import Codability`

## Helpers

### Invalid Element Strategy
By default Decodable will throw an error if a single element within an array or dictionary fails. `InvalidElementStrategy` is an enum that lets you control this behaviour. It has multiple cases:

- `remove`: Removes the element from the collection
- `fail`: Will fail the whole decoding. This is the default behaviour used by the decoders
- `fallback(value)`: This lets you provide a typed value in a type safe way
- `custom((EncodingError)-> InvalidElementStrategy)`: Lets you provide dynamic behaviour depending on the specific error that was throw which lets you lookup exactly which keys were involved

When decoding an array or dictionary use the `decodeArray` and `decodeDictionary` functions (there are also `IfPresent` variants as well).

The `InvalidElementStrategy` can either be passed into these functions, or a default can be set using `JSONDecoder().userInfo[.invalidElementStrategy]`, otherwise the default of `fail` will be used.

Given the following JSON:

```json
{
    "array": [1, "two", 3],
    "dictionary": {
        "one": 1,
        "two": "two",
        "three": 3
    }
}
```        
```swift
struct Object: Decodable {

    let array: [Int]
    let dictionary: [String: Int]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RawCodingKey.self)
        array = try container.decodeArray([Int].self, forKey: "array", invalidElementStrategy: .fallback(0))
        dictionary = try container.decodeDictionary([String: Int].self, forKey: "dictionary", invalidElementStrategy: .remove)
    }
}
```

```swift
let decoder = JSONDecoder()

// this will provide a default if none is passed into the decode functions
decoder.userInfo[.invalidElementStrategy] = InvalidElementStrategy<Any>.remove

let decodedObject = try decoder.decode(Object.self, from: json)
decodedObject.array == [1,0,3]
decodedObject.dictionary = ["one": 1, "three": 3]
```

### Any Codable
The downside of using Codable is that you can't encode and decode properties where the type is mixed or unknown, for example `[String: Any]`, `[Any]` or `Any`. 
These are sometimes a neccessary evil in many apis, and `AnyCodable` makes supporting these types easy.

There are 2 few different way to use it:

#### As a Codable property
The advantage of this is you can use the synthesized codable functions.
The downside though is that these values must be unwrapped using `AnyCodable.value`. You can add custom setters and getters on your objects to make accessing these easier though

```swift
struct AnyContainer: Codable {
    let dictionary: [String: AnyCodable]
    let array: [AnyCodable]
    let value: AnyCodable
}
```

#### Custom decoding and encoding functions

This lets you keep your normal structures, but requires using the `decodeAny` or `encodeAny` functions. If you have to implement a custom `init(from:)` or `encode` function for other reasons, this is the way to go. Behind the scenes this uses `AnyCodable` to do the coding, and then does a cast to your expect type in the case of decoding. 

```swift
struct AnyContainer: Codable {
    let dictionary: [String: Any]
    let array: [Any]
    let value: Any
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        dictionary = try container.decodeAny(.dictionary)
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
```

### Raw CodingKey
`RawCodingKey` can be used to provide dynamic coding keys. It also remove the need to create the standard `CodingKey` enum when you are only using those values in once place.

```swift
struct Object: Decodable {

    let int: Int
    let bool: Bool

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RawCodingKey.self)
        int = try container.decode(Int.self, forKey: "int")
        bool = try container.decode(Bool.self, forKey: "bool")
    }
}
```

### Generic Decoding functions
The default decoding functions on `KeyedDecodingContainer` and `UnkeyedDecodingContainer` all require an explicity type to be passed in. `Codabilty` adds generic functions to remove the need for this, making your `init(from:)` much cleaner. The `key` parameter also becomes unnamed.

All the helper functions provided by `Codabality` such as the `decodeAny`, `decodeArray` or `decodeDictionary` functions also have these generic variants including `IfPresent`.

```swift
struct Object: Decodable {

    let int: Int?
    let bool: Bool

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RawCodingKey.self)
        
        // old
        int = try container.decodeIfPresent(Int.self, forKey: "int")
        bool = try container.decode(Bool.self, forKey: "bool")
        
        // new
        int = try container.decodeIfPresent("int")
        bool = try container.decode("bool")
    }
}

```

## Attributions
Thanks to @mattt and [Flight-School/AnyCodable](https://github.com/Flight-School/AnyCodable) for the basis of `AnyCodable` support. [License](https://github.com/Flight-School/AnyCodable/blob/master/LICENSE.md)