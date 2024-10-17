import XCTest
import SwiftKanren
import TP3
 
class NatProofTests: XCTestCase {

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

  // -- x + 0 = x
  let t0 = ADTm["nat"].a("+")[0]
  // -- x + s(y) = s(x + y)
  let t1 = ADTm["nat"].a("+")[1]


  // Prove of: x + s(0) = s(x)
  func testProof0(){

    let expectedRes = Rule(
      Nat.add(Variable(named: "a"), Nat.succ(Nat.zero())),
      Nat.succ(Variable(named:"a"))
    )

    func proof() -> Rule {
      // -- x + s(0) = s(x + 0)
      let t2 = Proof.substitution(t1, Variable(named:"y"), Nat.zero())
      // -- s(x + 0) = s(x)
      let t3 = Proof.substitutivity(Nat.succ, [t0])
      // -- x + s(0) = s(x)
      let t4 = Proof.transitivity (t2, t3)

      return t4
    }

    self.TAssert(expectedRes, proof())
  }

  // TODO: Prove that: 0 + s(s(0)) = s(0 + s(0))
  func testProof1() {

    // 0+s(s(0)) = s(0+s(0))
    let expectedRes = Rule(
      Nat.add(Nat.zero(), Nat.succ(Nat.succ(Nat.zero()))),
      Nat.succ(Nat.add(Nat.zero(), Nat.succ(Nat.zero())))
    )

    // TODO: Change the code inside proof with your own code
    func proof() -> Rule {
      // x + s(s(0)) = s(x + s(0))
      let t2 = Proof.substitution(t1, Variable(named: "y"), Nat.succ(Nat.zero()))
      // 0 + s(s(0)) = s(0 + s(0))
      let t3 = Proof.substitution(t2, Variable(named: "x"), Nat.zero())
      return t3
    }

    TAssert(expectedRes, proof())
  }

  // TODO: Prove that: s(0) + 0 = s(0 + 0)
  // Care, commutativity has not been proved ! So, you cannot use it !
  func testProof2() {

    // s(0)+0 = s(0+0)
    let expectedRes = Rule(
      Nat.add(Nat.succ(Nat.zero()), Nat.zero()),
      Nat.succ(Nat.add(Nat.zero(), Nat.zero()))
    )

    // TODO: Change the code inside proof with your own code
    func proof() -> Rule {
      // s(0)+0 = s(0)
      let t2 = Proof.substitution(t0, Variable(named: "x"), Nat.succ(Nat.zero()))
      // 0+0 = 0
      let t3 = Proof.substitution(t0, Variable(named: "x"), Nat.zero())
      // s(0+0) = s(0)
      let t4 = Proof.substitutivity(Nat.succ, [t3])
      // s(0) = s(0+0)
      let t5 = Proof.symmetry(t4)
      // s(0)+0 = s(0+0)
      let t6 = Proof.transitivity(t2, t5)
      return t6
    }

    TAssert(expectedRes, proof())
  }

  // PROOF OF: suc(0) + x = suc(x)
  func testInductiveProof0() {

    // What we want to proove:
    //suc(0) + x -> suc(x)
    let conj = Rule(
      Nat.add(Nat.succ( Nat.zero()), Variable(named:"x")),
      Nat.succ( Variable(named: "x"))
    )

    // Inductive proof

    // 1) Initial case
    // suc(0) + 0 = suc(0)
    func zero_proof(t: Rule...) -> Rule{
      // Substitution t0: x -> s(0)
      // s(0)+0 = s(0)
      return Proof.substitution(t0, Variable(named: "x"), Nat.succ( Nat.zero()))
    }

    // 2) Inductive case
    // Our hypothesis:
    // s(0) + x = s(x)
    // Successor:
    // s(0) + s(x) = s(s(x))
    func succ_proof(t: Rule...) -> Rule{

      // Substitution ax1: x -> s(0)
      // s(0) + s(y) = s(s(0) + y)
      let t2 = Proof.substitution(t1, Variable(named: "x"), Nat.succ( Nat.zero()))

      // Substitutivity conj: succ
      // s(0) + x = s(x) -> s(s(0) + x) = s(s(x))
      let t3 = Proof.substitutivity (Nat.succ, [conj])

      // Transitivity t0 -> t1
      // s(0) + s(y) = s(s(y))
      return Proof.transitivity(t2, t3)
    }

    do {
      let theorem = try Proof.inductive(conj, Variable(named: "x"), ADTm["nat"], [
        "zero": zero_proof,
        "succ": succ_proof
        ]
      )
      print("Inductive result: \(theorem)")
    }
    catch ProofError.InductionFail {
      print("Induction failed!")
      XCTFail()
    }
    catch {
      XCTFail()
    }
  }

  // TODO: Prove that: x + 0 = 0 + x
  func testInductiveProof1(){

    // x + 0 = 0 + x
    let conj = Rule(
      Nat.add(Variable(named:"x"), Nat.zero()),
      Nat.add(Nat.zero(), Variable(named: "x"))
    )

    // TODO: Change the code inside proof with your own code
    // Initial case
    // 0+0 = 0+0
    func zero_proof(t: Rule...)->Rule{
      // 0+0 = 0
      let t2 = Proof.substitution(t0, Variable(named: "x"), Nat.zero())
      // 0 = 0+0
      let t3 = Proof.symmetry(t2)
      // 0+0 = 0+0
      let t4 = Proof.transitivity(t2, t3)
      return t4
    }

    // Inductive case
    // Our hypothesis:
    // x + 0 = 0 + x
    // Successor:
    // s(x)+0 = 0+s(x)
    // TODO: Change the code inside proof with your own code
    func succ_proof(t: Rule...)->Rule{
      // s(x)+0 = s(x)
      let t5 = Proof.substitution(t0, Variable(named: "x"), Nat.succ(Variable(named: "x")))

      // s(x+0) = s(x)
      let t6 = Proof.substitutivity(Nat.succ, [t0])
      // s(x) = s(x+0)
      let t7 = Proof.symmetry(t6)

      // s(x+0) = s(0+x)
      let t8 = Proof.substitutivity(Nat.succ, [conj])

      // 0+s(x) = s(0+x)
      let t9 = Proof.substitution(t1, Variable(named: "x"), Nat.zero())
      // s(0+x) = 0+s(x)
      let t10 = Proof.symmetry(t9)

      // s(x)+0 = s(x+0)
      let t11 = Proof.transitivity(t5, t7)
      // s(x)+0 = s(0+x)
      let t12 = Proof.transitivity(t11, t8)
      // s(x)+0 = 0+s(x)
      let t13 = Proof.transitivity(t12, t10)

      return t13
    }

    // 0 + 0 = 0 + 0
    let init_case = Rule(
      Nat.add(Nat.zero(), Nat.zero()),
      Nat.add(Nat.zero(), Nat.zero())
    )

    // s(x) + 0 = 0 + s(x)
    let inductive_case = Rule(
      Nat.add(Nat.succ(Variable(named: "x")), Nat.zero()),
      Nat.add(Nat.zero(), Nat.succ(Variable(named: "x")))
    )

    TAssert(zero_proof(), init_case)
    TAssert(succ_proof(), inductive_case)

    do {
      let theorem = try Proof.inductive(conj, Variable(named: "x"), ADTm["nat"], [
        "zero": zero_proof,
        "succ": succ_proof
        ]
      )
      print("Inductive result: \(theorem)")
    }
    catch ProofError.InductionFail {
      print("Induction failed!")
      XCTFail()
    }
    catch {
      XCTFail()
    }
  }

  static var allTests = [
    ("testProof0", testProof0),
    ("testProof1", testProof1),
    ("testProof2", testProof2),
    ("testInductiveProof0", testInductiveProof0),
    ("testInductiveProof1", testInductiveProof1),
  ]
}
