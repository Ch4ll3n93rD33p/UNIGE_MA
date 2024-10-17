public class Factory<Key> where Key: Comparable & Hashable {
  
  private var uniquenessTable: Set<SFDD<Key>> = []
  
  public var zero: SFDD<Key>! = nil
  public var one: SFDD<Key>! = nil
  
  public init() {
    self.zero = SFDD(factory: self, count: 0)
    self.uniquenessTable.insert(self.zero)
    self.one  = SFDD(factory: self, count: 1)
    self.uniquenessTable.insert(self.one)
  }
  
  // Create a triple (node): <term, takes, skips>
  public func makeNode(key: Key, take: SFDD<Key>, skip: SFDD<Key>) -> SFDD<Key> {
    guard take !== self.zero else {
      return skip
    }
    
    assert(take.isTerminal || key < take.key, "invalid SFDD ordering")
    assert(skip.isTerminal || key < skip.key, "invalid SFDD ordering")
    
    let (_, result) = self.uniquenessTable.insert(
      SFDD(key: key, take: take, skip: skip, factory: self))
    return result
  }
  
  // Convert a sequence [[1,2], [1,3]] into a SFDD
  public func make<S>(_ sequences: S) -> SFDD<Key>
    where S: Sequence, S.Element: Sequence, S.Element.Element == Key
  {
    // For each sequence
    return sequences.reduce(self.zero) { family, newSequence in
      let set = Set(newSequence)
      guard !set.isEmpty else {
        return family.union(self.one)
      }
      
      var newMember = self.one!
      // Construct a solution of our sequence, for example [1,2]
      // We apply a bottom up method
      for element in set.sorted().reversed() {
        newMember = self.makeNode(key: element, take: newMember, skip: self.zero)
      }
      return family.union(newMember)
    }
  }
  
  // sequences has the format: [1,2]
  public func make<S>(_ sequences: S...) -> SFDD<Key> where S: Sequence, S.Element == Key {
    return self.make(sequences)
  }
  
}



