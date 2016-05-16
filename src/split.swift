
/// String splitting and joining
public extension FastString {

    /// Join array of strings by using a delimiter string
    ///
    /// - parameter parts: parts to join
    /// - parameter delimiter: delimiter to insert
    /// - returns: combined string
    public static func join(parts: [FastString], delimiter: FastString) -> FastString {
        let result = FastString()

        if parts.count == 0 {
            // Nothing to join here
            return result
        }

        // calculate final length to reserve space
        var len = 0
        for part in parts {
            len += part.byteCount
        }
        len += delimiter.byteCount * (parts.count - 1)

        // reserve space
        let memory = UnsafeMutablePointer<UInt8>(allocatingCapacity: len + 1)
        memory[len] = 0

        // join string parts
        var index = 0
        for (idx, part) in parts.enumerated() {
            for c in part.makeByteIterator() {
                memory[index] = c
                index += 1
            }
            if idx < parts.count - 1 {
                for c in delimiter.makeByteIterator() {
                    memory[index] = c
                    index += 1
                }
            }
        }

        result.buffer.baseAddress!.deallocateCapacity(result.buffer.count + 1)
        result.buffer = UnsafeMutableBufferPointer(start: memory, count: len)
        return result
    }

    public static func join(parts: [String], delimiter: String) -> FastString {
        let fastParts = parts.map { part in
            return FastString(part)
        }
        return self.join(parts: fastParts, delimiter: FastString(delimiter))
    }

    /// Join array of strings by using a delimiter character
    ///
    /// - parameter parts: parts to join
    /// - parameter delimiter: delimiter to insert
    /// - returns: combined string
    public static func join(parts: [FastString], delimiter: Character) -> FastString {
        return self.join(parts: parts, delimiter: FastString(String(delimiter)))
    }

    public static func join(parts: [String], delimiter: Character) -> FastString {
        let fastParts = parts.map { part in
            return FastString(part)
        }
        return self.join(parts: fastParts, delimiter: delimiter)
    }

    /// Join array of strings
    ///
    /// - parameter parts: parts to join
    /// - returns: combined string
    public static func join(parts: [FastString]) -> FastString {

        // calculate final length to reserve space
        var len = 0
        for part in parts {
            len += part.byteCount
        }

        // reserve space
        var result = [UInt8]()
        result.reserveCapacity(len)

        // join string parts
        for part in parts {
            for c in part.makeByteIterator() {
                result.append(c)
            }
        }

        return FastString(array: result)
    }

    public static func join(parts: [String]) -> FastString {
        let fastParts = parts.map { part in
            return FastString(part)
        }
        return self.join(parts: fastParts)
    }

    /// Split string into array by using delimiter character
    ///
    /// - parameter character: delimiter to use
    /// - parameter maxSplits: (optional) maximum number of splits, set to 0 to allow unlimited splits
    /// - returns: array with string components
    public func split(character: UInt8, maxSplits: Int = 0) -> [FastString] {
        return self.buffer.split(separator: character, maxSplits: maxSplits).map { slice in
            return FastString(slice: slice)
        }
    }

    public func split(character: Character, maxSplits: Int = 0) -> [FastString] {
        return self.split(string: String(character), maxSplits: maxSplits)
    }


    /// Split string into array by using delimiter string
    ///
    /// - parameter string: delimiter to use
    /// - parameter maxSplits: (optional) maximum number of splits, set to 0 to allow unlimited splits
    /// - returns: array with string components
    public func split(string: FastString, maxSplits: Int = 0) -> [FastString] {
        var result = [FastString]()
        let positions = self.positions(string: string)
        var start = 0
        for idx in positions {
            let subString = self.subString(range: start..<idx)
            result.append(subString)
            start += subString.byteCount + string.byteCount
            if result.count == maxSplits {
                break
            }
        }
        result.append(self.subString(range: start..<self.byteCount))
        return result
    }

    public func split(string: String, maxSplits: Int = 0) -> [FastString] {
        return self.split(string: FastString(string), maxSplits: maxSplits)
    }
}