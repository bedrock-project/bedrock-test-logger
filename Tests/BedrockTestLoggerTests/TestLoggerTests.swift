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

import XCTest
import BedrockLog
import BedrockTestLogger

class TestLoggerTests: XCTestCase {
    
    private var logger: TestLogger!
    private var log: Log!
    private let label = "bedrock-test-logger"
    private let anotherLabel = "another-label"
    
    override func setUp() {
        logger = TestLogger()
        log = Log(label: label, handledBy: logger)
    }
    
    func testExample() {
        do {
            let loggerSpy = logger.spy(for: label)
            
            XCTAssertEqual(0, loggerSpy.count(.error))
            XCTAssertEqual(0, loggerSpy.count(.error, "Some message"))
            
            log.error("Some message")
            XCTAssertEqual(1, loggerSpy.count(.error))
            XCTAssertEqual(1, loggerSpy.count(.error, "Some message"))
            
            log.error("Another message")
            XCTAssertEqual(2, loggerSpy.count(.error))
            XCTAssertEqual(1, loggerSpy.count(.error, "Another message"))
            
            XCTAssertEqual(0, loggerSpy.count(.warning))
            XCTAssertEqual(0, loggerSpy.count(.warning, "Some message"))
        }
        do {
            let loggerSpy = logger.spy(for: anotherLabel)
            
            XCTAssertEqual(0, loggerSpy.count(.error))
            XCTAssertEqual(0, loggerSpy.count(.error, "Some message"))
        }
    }
}
