#if !canImport(ObjectiveC)
import XCTest

extension ADTTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ADTTests = [
        ("testBool", testBool),
        ("testInt", testInt),
        ("testNat", testNat),
        ("testSet", testSet),
        ("testSetEqual", testSetEqual),
        ("testSetNeedForEqual", testSetNeedForEqual),
    ]
}

extension ProofTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ProofTests = [
        ("testEquationalProof", testEquationalProof),
        ("testZeroSumIdentity", testZeroSumIdentity),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ADTTests.__allTests__ADTTests),
        testCase(ProofTests.__allTests__ProofTests),
    ]
}
#endif
