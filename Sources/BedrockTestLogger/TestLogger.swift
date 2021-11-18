//===----------------------------------------------------------------------===//
// Copyright (c) 2021 Roman Shamritskiy
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//===----------------------------------------------------------------------===//

import Foundation
import BedrockLog

/// Test implementation of the `LogHandler`.
///
/// Enables to check logging during the testing.
public class TestLogger: LogHandler {
    
    /// Provides an API to check if log record has been registered.
    ///
    ///  The Spy always operates in the context of some labeled log part.
    public class Spy {
        
        private let label: String
        private let logger: TestLogger
        
        fileprivate init(label: String, logger: TestLogger) {
            self.label = label
            self.logger = logger
        }
        
        /// Returns number of records with the given `level`.
        public func count(_ level: Log.Level) -> Int {
            logger.fetchRecordsWith(label: label)
                .filter { $0.level == level }
                    .count
        }
        
        /// Returns number of records with the given `level` and `message`.
        public func count(_ level: Log.Level, _ message: String) -> Int {
            logger.fetchRecordsWith(label: label)
                .filter { $0.level == level && $0.message.description == message }
                    .count
        }
    }
    
    private typealias LogRecord = (label: String, level: Log.Level, message: Log.Message)
    
    private let lock = NSLock()
    private var loggedRecords: [LogRecord] = []
    
    public init() {}
    
    public func handle(_ level: Log.Level, message: () -> Log.Message, label: String) {
        lock.lock()
        defer { lock.unlock() }
        
        loggedRecords.append((label, level, message()))
    }
    
    /// Returns ``Spy`` for the given log label.
    ///
    /// ``Spy`` is useful for checking the registered log records.
    public func spy(`for` label: String) -> Spy {
        return Spy(label: label, logger: self)
    }
    
    private func fetchRecordsWith(label: String) -> [LogRecord] {
        lock.lock()
        defer { lock.unlock() }
        
        return loggedRecords.filter { $0.label == label }
    }
}
