// Copyright (c) 2016 Johannes Schriewer.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// String replacement functions
public extension FastString {

    /// Return new string with `range` replaced by `replacement`
    ///
    /// - parameter range: range to replace
    /// - parameter replacement: replacement
    /// - returns: new string with substituted range
    public func replacing(range: Range<Int>, replacement: FastString) -> FastString {
        let before = self.subString(range: 0..<range.lowerBound)
        let after = self.subString(range: range.upperBound..<self.byteCount)
        return FastString.join(parts: [before, after], delimiter: replacement)
    }

    public func replacing(range: Range<Int>, replacement: String) -> FastString {
        return self.replacing(range: range, replacement: FastString(replacement))
    }

    /// Search for a substring and replace with other string
    ///
    /// - parameter searchTerm: substring to search
    /// - parameter replacement: replacement to substitute
    /// - returns: new string with applied substitutions
    public func replacing(searchTerm: FastString, replacement: FastString) -> FastString {
        if searchTerm.byteCount == 0 {
            return self
        }
        let comps = self.split(string: searchTerm)
        let replaced = FastString.join(parts: comps, delimiter: replacement)
        return replaced
    }

    public func replacing(searchTerm: String, replacement: String) -> FastString {
        return self.replacing(searchTerm: FastString(searchTerm), replacement: FastString(replacement))
    }

    /// Replace `range` in string with substitute, modifies self
    ///
    /// - parameter range: range to replace
    /// - parameter replacement: substitute
    public func replace(range: Range<Int>, replacement: FastString) {
        let capacity = self.byteCount - (range.upperBound - range.lowerBound) + replacement.byteCount
        let memory = UnsafeMutablePointer<UInt8>(allocatingCapacity: capacity + 1)
        memory[capacity] = 0

        var memIndex = 0
        for i in 0..<range.lowerBound {
            memory[memIndex] = self.buffer[i]
            memIndex += 1
        }
        for i in 0..<replacement.byteCount {
            memory[memIndex] = replacement.buffer[i]
            memIndex += 1
        }
        for i in range.upperBound..<self.byteCount {
            memory[memIndex] = self.buffer[i]
            memIndex += 1
        }

        self.buffer.baseAddress!.deallocateCapacity(self.buffer.count + 1)
        self.buffer = UnsafeMutableBufferPointer(start: memory, count: capacity)
    }

    public func replace(range: Range<Int>, replacement: String) {
        self.replace(range: range, replacement: FastString(replacement))
    }

    /// Replace substring in string, modifies self
    ///
    /// - parameter searchTerm: string to replace
    /// - parameter replacement: substitute
    public func replace(searchTerm: FastString, replacement: FastString) {
        if searchTerm.byteCount == 0 {
            return
        }
        let parts = self.split(string: searchTerm)

        let capacity = self.byteCount - (searchTerm.byteCount * (parts.count - 1)) + (replacement.byteCount * (parts.count - 1))
        let memory = UnsafeMutablePointer<UInt8>(allocatingCapacity: capacity + 1)
        memory[capacity] = 0

        var index = 0
        for part in parts {
            for c in part.buffer {
                memory[index] = c
                index += 1
            }
            if part !== parts.last! {
                for c in replacement.buffer {
                    memory[index] = c
                    index += 1
                }
            }
        }
        self.buffer.baseAddress!.deallocateCapacity(self.buffer.count + 1)
        self.buffer = UnsafeMutableBufferPointer(start: memory, count: capacity)
    }

    public func replace(searchTerm: String, replacement: String) {
        self.replace(searchTerm: FastString(searchTerm), replacement: FastString(replacement))
    }
}