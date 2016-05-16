
/// Character and substring search
public extension FastString {

    /// Search for a character in a string
    ///
    /// - parameter character: character to search
    /// - parameter index: (optional) start index, defaults to start or end of string depending on `reverse`
    /// - parameter reverse: (optional) search backwards from the `index` or the end of the string
    /// - returns: `String.Index` if character was found or `nil`
    public func position(character: UInt8, index: Int? = nil, reverse: Bool = false) -> Int? {
        if reverse {
            var i = index ?? self.byteCount
            while i >= 0 {
                if self.buffer[i] == character {
                    return i
                }
                i -= 1
            }
        } else {
            var i = index ?? 0
            while i < self.byteCount {
                if self.buffer[i] == character {
                    return i
                }
                i += 1
            }
        }
        return nil
    }

    public func position(character: Character, index: Int? = nil, reverse: Bool = false) -> Int? {
        return self.position(string: String(character), index: index, reverse: reverse)
    }

    /// Return array with string indices of found character positions
    ///
    /// - parameter character: character to search
    /// - returns: array of `String.Index` or empty array if character not found
    public func positions(character: UInt8) -> [Int] {
        var result = Array<Int>()
        var p = self.position(character: character)
        while p != nil  {
            result.append(p!)
            p = self.position(character: character, index: p! + 1)
        }
        return result
    }

    public func positions(character: Character) -> [Int] {
        return self.positions(string: String(character))
    }

    /// Search for a substring
    ///
    /// - parameter string: substring to search
    /// - parameter index: (optional) start index, defaults to start or end of string depending on `reverse`
    /// - parameter reverse: (optional) search backwards from the `index` or the end of the string
    /// - returns: `String.Index` if character was found or `nil`
    public func position(string: FastString, index: Int? = nil, reverse: Bool = false) -> Int? {
        if self.byteCount < string.byteCount {
            // search term longer than self
            return nil
        }

        if reverse {
            if index != nil && index! < string.byteCount {
                // can not find match because string is too short for match
                return nil
            }

            // start with index/self.endIndex and go back
            var i = index ?? self.byteCount - string.byteCount
            while i >= 0 {

                var idx = i

                // compare substring
                var match = true
                for character in string.buffer {
                    if self.buffer[idx] != character {
                        match = false
                        break
                    }
                    idx += 1
                }
                if match {
                    return i
                }
                i -= 1
            }
        } else {
            if index != nil && self.byteCount - index! < string.byteCount {
                // can not find match because string is too short for match
                return nil
            }
            let start = index ?? 0
            var i = start
            // iterate from start to end - search string length
            while i < self.byteCount {
                var idx = i

                // compare substring
                var match = true
                for character in string.buffer {
                    if self.buffer[idx] != character {
                        match = false
                        break
                    }
                    idx += 1
                }
                if match {
                    return i
                }
                i += 1
            }
        }
        return nil
    }

    public func position(string: String, index: Int? = nil, reverse: Bool = false) -> Int? {
        return self.position(string: FastString(string), index: index, reverse: reverse)
    }


    /// Return array with string indices of found substring positions
    ///
    /// - parameter string: substring to search
    /// - returns: array of `String.Index` or empty array if substring not found
    public func positions(string: FastString) -> [Int] {
        var result = Array<Int>()
        var p = self.position(string: string)
        while p != nil  {
            result.append(p!)
            p = self.position(string: string, index: p! + 1)
        }
        return result
    }

    public func positions(string: String) -> [Int] {
        return self.positions(string: FastString(string))
    }

    /// Search for a substring
    ///
    /// - parameter string: string to search
    /// - returns: `true` if the string contains the substring
    public func contains(string: FastString) -> Bool {
        return self.position(string: string) != nil
    }

    public func contains(string: String) -> Bool {
        return self.position(string: string) != nil
    }

    /// Search for a character
    ///
    /// - parameter char: character to search
    /// - returns: `true` if the string contains the character
    public func contains(character: UInt8) -> Bool {
        return self.position(character: character) != nil
    }

    public func contains(character: Character) -> Bool {
        return self.position(character: character) != nil
    }

    /// Check if a string has a prefix
    ///
    /// - parameter prefix: the prefix to check for
    /// - returns: true if the prefix was an empty string or the string has the prefix
    public func hasPrefix(_ prefix: FastString) -> Bool {
        if prefix.byteCount < 1 {
            // Every string has an empty prefix
            return true
        }
        return self.buffer.starts(with: prefix.buffer)
    }

    public func hasPrefix(_ prefix: String) -> Bool {
        return self.hasPrefix(FastString(prefix))
    }

    /// Check if a string has a suffix
    ///
    /// - parameter suffix: the suffix to check for
    /// - returns: true if the suffix was an empty string or the string has the suffix
    public func hasSuffix(_ suffix: FastString) -> Bool {
        if self.byteCount < suffix.byteCount {
            // String to short to be a match
            return false
        }

        if suffix.byteCount < 1 {
            // Every string has an empty suffix
            return true
        }

        let bufferSuffix = self.buffer.suffix(suffix.byteCount)
        var index = bufferSuffix.startIndex
        for c in suffix.buffer {
            if c != bufferSuffix[index] {
                return false
            }
            index = bufferSuffix.index(index, offsetBy: 1)
        }
        return true
    }

    public func hasSuffix(_ suffix: String) -> Bool {
        return self.hasSuffix(FastString(suffix))
    }

}
