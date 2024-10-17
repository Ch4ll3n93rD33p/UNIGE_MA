import XCTest
import SwiftKanren
import TP3

class StackProofsTests: XCTestCase {

  internal func tassert(_ a: Term,_ b: Term){
    let msg = "\(ADTm.pprint(a)) == \(ADTm.pprint(b))"
    print(msg)
    XCTAssertTrue(ADTm.eval(a).equals(ADTm.eval(b)), msg)
  }

  internal func TAssert(_ a: Rule, _ b: Rule){
    let msg = "(\(a)) == (\(b))"
    print(msg)
    XCTAssertTrue(a.equals(b),msg)
  }

  internal func FAssert(_ a: Rule, _ b: Rule){
    let msg = "(\(a)) != (\(b))"
    print(msg)
    XCTAssertFalse(a.equals(b),msg)
  }
  
  // ------------------------------------------------- //
  // Axioms that we use as theorems to make our proofs
  // ------------------------------------------------- //
  
  // pop(empty) = empty
  let t_pop0 = ADTm["stack"].a("pop")[0]
  // pop(cons(n,rest)) = rest
  let t_pop1 = ADTm["stack"].a("pop")[1]
  // top(cons(n,rest)) = n
  let t_top1 = ADTm["stack"].a("top")[1]
  // x - 0 = x
  let t_sub0 = ADTm["nat"].a("-")[0]
  // 0 - x = 0
  let t_sub1 = ADTm["nat"].a("-")[1]
  // s(x) - s(y) = x - y
  let t_sub2 = ADTm["nat"].a("-")[2]
  // 0 > x = false
  let t_gt0 = ADTm["nat"].a(">")[0]
  // s(x) > 0 = true
  let t_gt1 = ADTm["nat"].a(">")[1]
  // s(x) > s(y) = x > y
  let t_gt2 = ADTm["nat"].a(">")[2]
  // size(empty) = 0
  let t_size0 = ADTm["stack"].a("size")[0]
  // size(cons(n,rest)) = s(size(rest))
  let t_size1 = ADTm["stack"].a("size")[1]
  // --------------------------------------------------

  // Prove of: cons(2, empty) = pop(cons(4,cons(2,empty)))
  func testProof0() {
    
    // cons(2, empty) = pop(cons(4,cons(2,empty)))
    let expectedRes = Rule(
      Stack.cons(Nat.n(2), Stack.empty()),
      Stack.pop(Stack.cons(Nat.n(4), Stack.cons(Nat.n(2), Stack.empty())))
    )
    
    func proof() -> Rule {
      //(Substitution dans t_pop1: [n := 4]): pop(cons(n,rest)) = rest => pop(cons(4,rest)) = rest
      let t0 = Proof.substitution(t_pop1, Variable(named: "n"), Nat.n(4))
      //(Substitution dans t0: [rest := cons(2,empty)]): pop(cons(4,rest)) = rest => pop(cons(4,cons(2,empty))) = cons(2,empty)
      let t1 = Proof.substitution(t0, Variable(named: "rest"), Stack.cons(Nat.n(2), Stack.empty()))
      //(Symmetry on t1) pop(cons(4,cons(2,empty))) = cons(2,empty) => cons(2,empty) = pop(cons(4,cons(2,empty)))
      let t2 = Proof.symmetry(t1)
      
      return t2
    }

    TAssert(expectedRes, proof())
  }
  
  // TODO: Prove that: cons(2, pop(cons(1,empty))) = cons(2, empty)
  func testProof1() {
    // cons(2, pop(cons(1,empty))) = cons(2, empty)
    let expectedRes = Rule(
      Stack.cons(Nat.n(2), Stack.pop(Stack.cons(Nat.n(1), Stack.empty()))),
      Stack.cons(Nat.n(2), Stack.empty())
    )
    
    // TODO: Change the code inside proof with your own code
    func proof() -> Rule {
      // pop(cons(1,rest)) = rest
      let t0 = Proof.substitution(t_pop1, Variable(named: "n"), Nat.n(1))
      // pop(cons(1,empty)) = empty
      let t1 = Proof.substitution(t0, Variable(named: "rest"), Stack.empty())
      // cons(2,pop(cons(1,empty))) = cons(2,empty)
      let t2 = Proof.substitutivity(Stack.cons, [Proof.reflexivity(Nat.n(2)),t1])

      return t2
    }
    
    TAssert(expectedRes, proof())
  }
  
  // TODO: Prove that: top(cons(3, cons(42, empty))) = 4 - 1
  func testProof2() {
    
    // top(cons(3, cons(42, empty))) = 4 - 1
    let expectedRes = Rule(
      Stack.top(Stack.cons(Nat.n(3), Stack.cons(Nat.n(42), Stack.empty()))),
      Nat.sub(Nat.n(4), Nat.n(1))
    )
    
    // TODO: Change the code inside proof with your own code
    func proof() -> Rule {
      // top(cons(3,rest)) = 3
      let t0 = Proof.substitution(t_top1, Variable(named: "n"), Nat.n(3))
      // top(cons(3,cons(42,empty))) = 3
      let t1 = Proof.substitution(t0, Variable(named: "rest"), Stack.cons(Nat.n(42), Stack.empty()))

      // 3-0 = 3
      let t2 = Proof.substitution(t_sub0, Variable(named: "x"), Nat.n(3))
      // s(3)-s(y) = 3-y
      let t3 = Proof.substitution(t_sub2, Variable(named: "x"), Nat.n(3))
      // s(3)-s(0) = 3-0
      let t4 = Proof.substitution(t3, Variable(named: "y"), Nat.zero())
      // s(3)-s(0) = 3
      let t5 = Proof.transitivity(t4, t2)
      // 3 = s(3)-s(0)
      let t6 = Proof.symmetry(t5)

      let t7 = Proof.transitivity(t1, t6)

      return t7
    }
    
    TAssert(expectedRes, proof())
  }
  
  // TODO: Prove that: (size(cons(n,empty)) > size(empty)) = true
  func testProof3() {
    
    let expectedRes = Rule(
      Nat.gt(
        Stack.size(Stack.cons(Variable(named: "n"), Stack.empty())),
        Stack.size(Stack.empty())
      ),
      Boolean.True()
    )
    
    // TODO: Change the code inside proof with your own code
    func proof() -> Rule {
      // size(cons(n,empty)) = s(size(empty))
      let t0 = Proof.substitution(t_size1, Variable(named: "rest"), Stack.empty())
      // size(cons(n,empty))>0 = s(size(empty))>0
      let t1 = Proof.substitutivity(Nat.gt, [t0,Proof.reflexivity(Nat.zero())])

      // s(size(empty))>0 = True
      let t2 = Proof.substitution(t_gt1, Variable(named: "x"), Stack.size(Stack.empty()))

      // size(cons(n,empty))>size(empty) = size(cons(n,empty))>0
      let t3 = Proof.substitutivity(Nat.gt, [Proof.reflexivity(Stack.size(Stack.cons(Variable(named: "n"), Stack.empty()))), t_size0])

      // size(cons(n,empty))>size(empty) = s(size(empty))>0
      let t4 = Proof.transitivity(t3, t1)
      // size(cons(n,empty))>size(empty) = True
      let t5 = Proof.transitivity(t4, t2)

      return t5
    }
    
    TAssert(expectedRes, proof())
  }
  
  static var allTests = [
    ("testProof0", testProof0),
    ("testProof1", testProof1),
    ("testProof2", testProof2),
    ("testProof3", testProof3),
  ]
}
