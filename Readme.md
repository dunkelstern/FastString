# FastString

`FastString` is a String class for Swift 3 that primarily wants to deliver a performant string implementation.

I have nothing against the Swift internal implementation of the `String` datatype but the unicode safety of that implementation comes with a performance toll.

`FastString` is licensed under the Apache 2 License, see LICENSE for details.

So what does this library do?

## Basic functionality

`FastString` is a class (not a struct like the Swift string is), primarily because it manages it's own memory (just a big chunk of raw memory accessed with a `UnsafeBufferPointer`)

### Initialization

To initialize you have multiple functions (much more than the Swift string):

- `init()`: Creates an empty string
- `init(_ string: String)`: Initialize with contents of a Swift string
- `init?(nullTerminatedCString: UnsafePointer<Int8>)`: Initialize with a `NULL` terminated c string, be aware that the string is checked if it contains valid UTF-8
- `init(array: [Int8])`: Initialize with an array
- `init(array: [UInt8])`: Same as above
- `init(buffer: UnsafeBufferPointer<UInt8>)`: Initialize with a buffer pointer
- `init(fastString: FastString)`: Copying initializer

### Equality

There are overloads for `==`:

- `public func ==(lhs: FastString, rhs: FastString) -> Bool`
- `public func ==(lhs: FastString, rhs: String) -> Bool`

So you may test `FastString` equality and limited equality for a `FastString` and a `String` (grapheme-cluster equality will break!)

### Appending

Appending to a `FastString` usually means a copy operation of the complete buffer, so appending is O(n) where n is the length of the resulting string.

(**FIXME**: How can we get more performance? `malloc`/`realloc` instead of using the `UnsafeMutablePointer` initializer?)

For appending just use one of the operator overloads:

- `public func +(lhs: FastString, rhs: FastString) -> FastString`
- `public func +=(lhs: inout FastString, rhs: FastString)`
- `public func +(lhs: FastString, rhs: String) -> FastString`
- `public func +=(lhs: inout FastString, rhs: String)`
- `public func +(lhs: String, rhs: FastString) -> String`
- `public func +=(lhs: inout String, rhs: FastString)`

... or call the corresponding function on a `FastString` instance:

- `public func appending(_ string: FastString) -> FastString`
- `public func appending(_ string: String) -> FastString`
- `public func append(_ string: FastString)`
- `public func append(_ string: String)`

### Converting to other types

You are not locked in when using `FastString` for some operations, but be aware that converting to another type usually copies the data, so convert as late as possible (and as early as possible into `FastString`):

- `public func toString() -> String?`: Convert to Swift string, may return `nil` if the string is not valid UTF-8
- `public func toArray() -> [UInt8]`: Convert to array, the array is not zero terminated!

### Iterating over content

If you want to iterate over the content of the string you'll have two methods for that:

- `public func makeByteIterator() -> AnyIterator<UInt8>`: Makes an iterator that throws `UInt8` values at you
- `public func makeCharacterIterator(replaceInvalid: Character? = nil) -> AnyIterator<Character>`: This one gives you Swift `Character` instances, if you set `replaceInvalid` to a character then invalid UTF-8 Bytes will be replaced with that character, if it is set to `nil` the iterator stops at the first error

Iterating over bytes is **fast** so it is perfect for crafting parsers, etc. Iterating over `Character`s is relatively fast as UTF-8 validation is simple but it has the `Character`-Instanciation overhead.

You have the option to subscript with an integer to get to the UTF-8 bytes too.

(**TODO**: Subscript)

## Substrings

To create substrings there are 3 functions:

- `public func subString(range: Range<Int>) -> FastString`: Use a range to create a substring, if out of range, returns a empty string
- `public func subString(toIndex index: Int) -> FastString`: Substring from start to defined index
- `public func subString(fromIndex index: Int) -> FastString`: Substring from index to end

## Splitting and joining

You may split a string by character or string:

- `public func split(character: UInt8, maxSplits: Int = 0) -> [FastString]`: Split a string by a character, set `maxSplits` to limit the count of objects in the resulting array. There is an overload for `Character`.
- `public func split(string: FastString, maxSplits: Int = 0) -> [FastString]`: Split by substring. There is an overload for `String`

To join multiple strings use the static functions on `FastString`:

- `public static func join(parts: [FastString], delimiter: FastString) -> FastString`: Join multiple strings with a delimiter. There is an overload for `String`, `Character` and `UInt8` (**FIXME**: `UInt8` missing)
- `public static func join(parts: [FastString]) -> FastString`: Join a list of strings without a delimiter. There is an overload for `String`

## Search

Searching in `FastString` is at most O(n) where n is the string length in bytes, but may be faster for some operations (like `hasPrefix` and `hasSuffix`). The following functions are implemented:

- `public func position(character: UInt8, index: Int? = nil, reverse: Bool = false) -> Int?`: Returns first (or last, see the `reverse` flag) found occurence of the character. If `index` is set search starts at that index.
- `public func positions(character: UInt8) -> [Int]`: Returns an array of all positions of `character`
- `public func contains(character: UInt8) -> Bool`: Returns `true` if the string contains the character.

There are overloads for `UInt8`, `Character`, `FastString` and `String` for each of these functions.

- `public func hasPrefix(_ prefix: FastString) -> Bool`: Returns `true` if the string begins with `prefix`
- `public func hasSuffix(_ suffix: FastString) -> Bool`: Returns `true` if the string ends with `suffix`

There are overloads for `FastString` and `String` for each of these functions.

## Replace

Replacing on a `FastString` usually means copying the complete buffer, so replacing will be O(n) where n is the length of the resulting string.

(**FIXME**: How can we get more performance? `malloc`/`realloc` instead of using the `UnsafeMutablePointer` initializer?)

- `public func replacing(range: Range<Int>, replacement: FastString) -> FastString`: Replace a sub-range of a string and return a new string
- `public func replacing(searchTerm: FastString, replacement: FastString) -> FastString`: Replace a search term with a replacement string and return a new string
- `public func replace(range: Range<Int>, replacement: FastString)`: Replace a sub-range in place with a new string (**FIXME**: needs to copy all the data)
- `public func replace(searchTerm: FastString, replacement: FastString)`: Replace a search term in place with a new string (**FIXME**: needs to copy all the data)

All these functions have overloads for `FastString` and `String` parameters.

