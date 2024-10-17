import XCTest
@testable import Homework

final class HomeworkTests: XCTestCase {


  func testCount() {
    let factory = Factory<Int>()

    XCTAssertEqual(0, factory.zero.count)
    XCTAssertEqual(1, factory.one.count)
    XCTAssertEqual(1, factory.make([1, 2]).count)
    XCTAssertEqual(2, factory.make([1, 2], [1, 3]).count)
    XCTAssertEqual(2, factory.make([1, 2], []).count)

  }

  func testContains() {
    let factory = Factory<Int>()
    var family: SFDD<Int>

    family = factory.zero
    XCTAssertFalse(family.contains([]))

    family = factory.one
    XCTAssertTrue (family.contains([]))
    XCTAssertFalse(family.contains([1]))

    family = factory.make([1])
    XCTAssertFalse(family.contains([]))
    XCTAssertTrue (family.contains([1]))
    XCTAssertFalse(family.contains([2]))

    family = factory.make([1, 2], [1, 3], [1, 4])
    XCTAssertTrue (family.contains([1, 2]))
    XCTAssertTrue (family.contains([1, 3]))
    XCTAssertTrue (family.contains([1, 4]))
    XCTAssertFalse(family.contains([]))
    XCTAssertFalse(family.contains([1]))
    XCTAssertFalse(family.contains([1, 5]))
  }


  func testUnion() {
    let factory = Factory<Int>()

    // Union of two empty families.
    let eue = factory.make([]).union(factory.make([]))
    XCTAssertEqual(eue, factory.one)

    // Union of two identical families.
    let family = factory.make([1, 2, 3])
    XCTAssertEqual(family.union(family), family)

    // Union of different families.
    let families = [
      // Families with overlapping elements.
      ([1, 3, 9], [1, 3, 8]),
      ([1, 3, 8], [1, 3, 9]),
      // Families with disjoint elements.
      ([1, 3, 9], [0, 2, 4]),
      ([9, 2, 4], [1, 3, 9]),
      ]
    for (fa, fb) in families {
      let a   = factory.make(fa)
      let b   = factory.make(fb)
      let aub = a.union(b)
      let bua = b.union(a)

      XCTAssertEqual(Set(aub), Set([Set(fa), Set(fb)]))
      XCTAssertEqual(aub, bua)
    }
  }


  func testIntersection() {
    let factory = Factory<Int>()

    // Intersection of two empty families.
    let eue = factory.make([]).intersection(factory.make([]))
    XCTAssertEqual(eue, factory.one)

    // Intersection of two identical families.
    let family = factory.make([[1, 3, 8], [0, 2, 4]])
    XCTAssertEqual(family.intersection(family), family)

    // Intersection of families with overlapping elements.
    let overlappingFamilies = [
      ([[1, 3, 9], [0, 2, 4]], [[1, 3, 9], [5, 6, 7]]),
      ([[1, 3, 9], [5, 6, 7]], [[1, 3, 9], [0, 2, 4]]),
      ]
    for (fa, fb) in overlappingFamilies {
      let a   = factory.make(fa)
      let b   = factory.make(fb)
      let aib = a.intersection(b)
      let bia = b.intersection(a)

      XCTAssertEqual(Set(aib), Set([Set([1, 3, 9])]))
      XCTAssertEqual(aib, bia)
    }

    // Intersection of families with disjoint elements.
    let disjointFamilies = [
      ([[1, 3, 9], [0, 2, 4]], [[1, 3, 0], [5, 6, 7]]),
      ([[1, 3, 0], [5, 6, 7]], [[1, 3, 9], [0, 2, 4]]),
      ]
    for (fa, fb) in disjointFamilies {
      let a   = factory.make(fa)
      let b   = factory.make(fb)
      let aib = a.intersection(b)
      let bia = b.intersection(a)

      XCTAssertEqual(aib, factory.zero)
      XCTAssertEqual(aib, bia)
    }
  }
  

  func testSubtracting() {
    let factory = Factory<Int>()
    
    // Subtracting between top and bot
    let b0 = factory.one.subtracting(factory.zero)
    XCTAssertEqual(b0, factory.one)

    // Subtraction between two empty families.
    let ese = factory.make([]).subtracting(factory.make([]))
    XCTAssertEqual(ese, factory.zero)

    // Subtraction between two identical families.
    let family = factory.make([[1, 3, 8], [0, 2, 4]])
    XCTAssertEqual(family.subtracting(family), factory.zero)

    // Subtraction between families with overlapping elements.
    let overlappingA = factory.make([[1, 3, 9], [0, 2, 4]])
    let overlappingB = factory.make([[1, 3, 9], [5, 6, 7]])
    let overlappingC = overlappingA.subtracting(overlappingB)
    XCTAssertEqual(Set(overlappingC), Set([Set([0, 2, 4])]))

    // Subtraction between families with disjoint elements.
    let disjointA = factory.make([[1, 3, 9], [0, 2, 4]])
    let disjointB = factory.make([[1, 3, 0], [5, 6, 7]])
    let disjointC = disjointA.subtracting(disjointB)
    XCTAssertEqual(Set(disjointC), Set([Set([1, 3, 9]), Set([0, 2, 4])]))
  }

  func testEquality() {
    let factory = Factory<Int>()
    XCTAssertEqual(factory.zero, factory.zero)
    XCTAssertEqual(factory.one, factory.one)
    
    //  Create two SFDD with same values in the set is nothing more than the same reference.
    let a0 = factory.make([1,4,42])
    let a1 = factory.make([1,4,42])
    XCTAssertEqual(a0, a1)
    
    // Union between the same SFDD
    let a2 = a0.union(a0)
    XCTAssertEqual(a2, a0)
    
    // Union is commutative
    let a3 = factory.make([3,5])
    XCTAssertEqual(a0.union(a3), a3.union(a0))
    
    // Intersection between the same SFDD
    let a4 = a0.intersection(a0)
    XCTAssertEqual(a4, a0)
    
    // Removing [3,5] from a5, we get the same reference as a0
    let a5 = factory.make([[1,4,42], [3,5]])
    XCTAssertEqual(a5.subtracting(a3), a0)
  }
  

  static var allTests = [
      ("testCount", testCount),
      ("testContains", testContains),
      ("testUnion", testUnion),
      ("testIntersection", testIntersection),
      ("testSubtracting", testSubtracting),
      ("testEquality", testEquality)
    ]
}
