import XCTest
@testable import Homework

final class HomeworkTests: XCTestCase {

  func testKripke() {
    let nodes: [String:Set<AP>] = [
      "s0":[.x,.y,.z],
      "s1": [.x,.y],
      "s2": [.y,.z],
      ]

    let transitions_not_exist: Set<[String]> = [
      ["s0","s1"],
      ["s0","s99"]
    ]

    let transitions_too_many_args: Set<[String]> = [
      ["s0","s1", "s2"],
      ["s0","s1"]
    ]

    let kripke1 = Kripke(nodes: nodes, transitions: transitions_not_exist)
    let kripke2 = Kripke(nodes: nodes, transitions: transitions_too_many_args)

    XCTAssertNil(kripke1)
    XCTAssertNil(kripke2)

  }

  func testReduceCTL() {

    let af: CTL = .af(.not(.ap(.x)))
    let endAf: CTL = .not(.eg(.ap(.x)))
    print("\(af) -> \(CTL.reduce(af))")
    XCTAssertEqual(endAf, CTL.reduce(af))

    let start1: CTL = .aw(.not(.ap(.x)), .not(.ap(.y)))
    let end1: CTL = .not(.eu(.ap(.y), .not(.or(.not(.ap(.x)), .not(.ap(.y))))))
    print("\(start1) -> \(CTL.reduce(start1))")
    XCTAssertEqual(end1, CTL.reduce(start1))

    let start2: CTL = .au(.ap(.x), .ap(.z))
    let end2: CTL = .not(.or(.eg(.not(.ap(.z))), .eu(.not(.ap(.z)), .not(.or(.ap(.x), .ap(.z))))))

    print("\(start2) -> \(CTL.reduce(start2))")
    XCTAssertEqual(end2, CTL.reduce(start2))


    let start3: CTL = .au(.true, .or(.ap(.x), .not(.ex(.ap(.x)))))
    let end3: CTL =  .not(.or(.eg(.not(.or(.ap(.x), .not(.ex(.ap(.x)))))) , .eu(.not(.or(.ap(.x), .not(.ex(.ap(.x))))), .not(.true))))

    print("\(start3) -> \(end3)")
    print("\(start3) -> \(CTL.reduce(start3))")
    XCTAssertEqual(CTL.reduce(CTL.reduce(start3)), end3)

  }

  func testComputeCTL() {

    let nodes: [String:Set<AP>] = [
      "s0": [.x,.y,.z],
      "s1": [.x,.y],
      "s2": [.y,.z],
      "s3": [.x],
      "s4": [.y],
      "s5": [.x, .z],
      "s6": [.z],
      "s7": []
      ]

    let transitions: Set<[String]> = [
      ["s0","s2"], ["s0","s4"],
      ["s1","s5"],
      ["s2","s1"], ["s2","s4"],
      ["s3","s0"], ["s3","s1"], ["s3","s7"],
      ["s4","s1"],
      ["s5","s1"],
      ["s6","s3"], ["s6","s4"],
      ["s7","s5"], ["s7","s6"]
    ]

    let kripke = Kripke(nodes: nodes, transitions: transitions)

    let ctl0: CTL = .true
    print("ctl0: \(kripke!.compute(CTL.reduce(ctl0)))")
    XCTAssertEqual(kripke?.compute(ctl0), ["s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7"])

    let ctl1: CTL = .ap(.x)
    print("ctl1: \(kripke!.compute(CTL.reduce(ctl1)))")
    XCTAssertEqual(kripke?.compute(.ap(.x)), ["s0", "s1", "s3", "s5"])

    let ctl2: CTL = .not(.ap(.x))
    print("ctl2: \(kripke!.compute(CTL.reduce(ctl2)))")
    XCTAssertEqual(kripke?.compute(ctl2), ["s2", "s4", "s6", "s7"])

    let ctl3: CTL = .ex(.ap(.x))
    print("ctl3: \(kripke!.compute(CTL.reduce(ctl3)))")
    XCTAssertEqual(kripke?.compute(ctl3), ["s1", "s2", "s3", "s4", "s5", "s6", "s7"])

    let ctl4: CTL = .ef(.ap(.x))
    print("ctl4: \(kripke!.compute(CTL.reduce(ctl4)))")
    XCTAssertEqual(kripke?.compute(ctl4), ["s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7"])

    let ctl5: CTL = .eg(.ap(.x))
    print("ctl5: \(kripke!.compute(CTL.reduce(ctl5)))")
    XCTAssertEqual(kripke?.compute(ctl5), ["s1", "s3","s5"])

    let ctl6: CTL = .ag(.ap(.x))
    print("ctl6: \(kripke!.compute(CTL.reduce(ctl6)))")
    XCTAssertEqual(kripke?.compute(CTL.reduce(ctl6)), ["s1", "s5"])

    let ctl7: CTL = .af(.ag(.ap(.x)))
    print(CTL.reduce(ctl7))
    print("ctl7: \(kripke!.compute(CTL.reduce(ctl7)))")
    XCTAssertEqual(kripke?.compute(CTL.reduce(ctl7)), ["s0", "s1", "s2", "s4", "s5"])

    let ctl8: CTL = .eu(.ap(.y), .ap(.x))
    print(CTL.reduce(ctl8))
    print("ctl8: \(kripke!.compute(CTL.reduce(ctl8)))")
    XCTAssertEqual(kripke?.compute(CTL.reduce(ctl8)), ["s0", "s1", "s2", "s3", "s4", "s5"])

  }

  static var allTests = [
    ("testKripke", testKripke),
    ("testReduceCTL", testReduceCTL),
    ("testComputeCTL", testComputeCTL)
  ]

}
