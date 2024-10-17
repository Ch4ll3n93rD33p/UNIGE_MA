import XCTest
import SwiftKanren
import TP3

class StackTests: XCTestCase {
  
  internal func TAssert(_ a: Term,_ b: Term){
    let msg = "\(ADTm.pprint(a)) == \(ADTm.pprint(b))"
//    print(msg)
    XCTAssertTrue(ADTm.eval(a).equals(ADTm.eval(b)), msg)
  }
  
  internal func FAssert(_ a: Term,_ b: Term){
    let msg = "\(ADTm.pprint(a)) != \(ADTm.pprint(b))"
//    print(msg)
    XCTAssertFalse(ADTm.eval(a).equals(ADTm.eval(b)),msg)
  }
  
  func testStackPop() {
    // pop(empty) = empty
    let s0 = Stack.pop(Stack.empty())
    TAssert(s0, Stack.empty())
    // pop(cons(0, empty)) = empty
    let s1 = Stack.pop(Stack.cons(Nat.zero(), Stack.empty()))
    TAssert(s1, Stack.empty())
  }
  
  func testStackSize() {
    // size(empty) = 0
    TAssert(Stack.size(Stack.empty()), Nat.zero())
    // size(cons(0, cons(0, empty)))
    let s0 = Stack.cons(Nat.zero(), Stack.cons(Nat.zero(), Stack.empty()))
    TAssert(Stack.size(s0), Nat.n(2))
  }
  
  func testStackTop() {
    // top(empty) = vFail
    TAssert(Stack.top(Stack.empty()), vFail)
    // top(cons(4, cons(42, empty)))
    let s0 = Stack.cons(Nat.n(4), Stack.cons(Nat.n(42), Stack.empty()))
    TAssert(Stack.top(s0), Nat.n(4))
  }
  
  func testStackN() {
    // [] = empty
    TAssert(Stack.n([]), Stack.empty())
    // [4,42] = cons(4,cons(42,empty))
    let s0 = Stack.cons(Nat.n(0), Stack.cons(Nat.n(1), Stack.empty()))
    let s1 = Stack.n([Nat.n(0),Nat.n(1)])
    TAssert(s0, s1)
  }
  
   
  static var allTests = [
    ("testStackPop", testStackPop),
    ("testStackSize", testStackSize),
    ("testStackTop", testStackTop),
    ("testStackN", testStackN),
  ]
}
