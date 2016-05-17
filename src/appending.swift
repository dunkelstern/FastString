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

/// String appending
public extension FastString {

    /// Return new string by appending other string
    ///
    /// - parameter string: string to append
    /// - returns: new string instance with both strings concatenated
    public func appending(_ string: FastString) -> FastString {
        let result = FastString()

        if self.byteCount == 0 && string.byteCount == 0 {
            // 2 empty strings -> return empty string
            return result
        }

        let count = self.byteCount + string.byteCount
        let memory = UnsafeMutablePointer<UInt8>(allocatingCapacity: count + 1)
        memory[count] = 0

        var index = 0
        for c in self.buffer {
            memory[index] = c
            index += 1
        }
        for c in string.buffer {
            memory[index] = c
            index += 1
        }

        result.buffer.baseAddress!.deallocateCapacity(result.buffer.count + 1)
        result.buffer = UnsafeMutableBufferPointer(start: memory, count: count)
        return result
    }

    public func appending(_ string: String) -> FastString {
        return self.appending(FastString(string))
    }

    /// Append string to self
    ///
    /// - parameter string: string to append
    public func append(_ string: FastString) {
        if string.byteCount == 0 {
            // Nothing to do
            return
        }

        let count = self.byteCount + string.byteCount
        let memory = UnsafeMutablePointer<UInt8>(allocatingCapacity: count + 1)
        memory[count] = 0

        var index = 0
        for c in self.buffer {
            memory[index] = c
            index += 1
        }
        for c in string.buffer {
            memory[index] = c
            index += 1
        }

        self.buffer.baseAddress!.deallocateCapacity(self.buffer.count + 1)
        self.buffer = UnsafeMutableBufferPointer(start: memory, count: count)
    }

    public func append(_ string: String) {
        self.append(FastString(string))
    }
}

public func +(lhs: FastString, rhs: FastString) -> FastString {
    return lhs.appending(rhs)
}

public func +=(lhs: inout FastString, rhs: FastString) {
    lhs.append(rhs)
}

public func +(lhs: FastString, rhs: String) -> FastString {
    return lhs.appending(rhs)
}

public func +=(lhs: inout FastString, rhs: String) {
    lhs.append(rhs)
}

public func +(lhs: String, rhs: FastString) -> String {
    return lhs + rhs.description
}

public func +=(lhs: inout String, rhs: FastString) {
    lhs += rhs.description
}
