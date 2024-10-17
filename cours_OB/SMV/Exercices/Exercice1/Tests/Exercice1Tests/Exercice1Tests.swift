import XCTest
@testable import Exercice1

class Exercice1Tests: XCTestCase {

  func testFibo() {
    print(fibo(10))
    XCTAssertEqual(fibo(10), 55)
  }

  func testIsPalindrome() {
    print(isPalindrome("madam"))
    XCTAssertEqual(isPalindrome("madam"), true)

  }

  static var allTests = [
      ("testFibo", testFibo),
      ("testPalindrome", testIsPalindrome),
  ]
}
