public class SFDD<Key>: Hashable where Key: Comparable & Hashable {
  
  init(key: Key, take: SFDD, skip: SFDD, factory: Factory<Key>) {
    self.key = key
    self.take = take
    self.skip = skip
    self.factory = factory
    self.count = take.count + skip.count
  }
  
  init(factory: Factory<Key>, count: Int) {
    self.key     = nil
    self.take    = nil
    self.skip   = nil
    self.factory = factory
    self.count   = count
  }
  
  
  public let key: Key!
  public let take: SFDD!
  public let skip: SFDD!
  public let count: Int
  
  public unowned let factory: Factory<Key>
  
  public var isZero    : Bool { return self === self.factory.zero }
  public var isOne     : Bool { return self === self.factory.one }
  public var isTerminal: Bool { return self.isZero || self.isOne }
  public var isEmpty   : Bool { return self.isZero }
  
  // Computed properties to compute which is the terminal of the path with only skip
  private var skipMost: SFDD {
    var result = self
    while !result.isTerminal {
      result = result.skip
    }
    return result
  }
  
  // Need to conform the protocol hashable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(key)
    hasher.combine(take)
    hasher.combine(skip)
    hasher.combine(count)
  }
  
  // Need to conform the protocol Comparable
  public static func == (lhs: SFDD, rhs: SFDD) -> Bool {
    return (lhs.key == rhs.key)
      && (lhs.take == rhs.take)
      && (lhs.skip == rhs.skip)
      && (lhs.count == rhs.count)
  }
  
  
  /// Returns `true` if the SFDD contains the given element.
  public func contains(_ element: Set<Key>) -> Bool {
    // TODO
    let factKey = self.key // key of the factory ?
    var r = false
    for eleKey in element {

      if factKey==eleKey {
        r = true

      }
    }

    // Change return
    print(r)
    return r
  }
  
  
  /// Returns the union of this SFDD with another one.
  // THINK TO USE makeNode in Factory !!!!!^1000000
  public func union(_ other: SFDD) -> SFDD {
    if self.isZero || (self === other) {
      return other
    } else if other.isZero {
      return self
    }

    // Remove '= self.factory.zero' when you will compute result in TODO part
    let result: SFDD = self.factory.zero

    // TODO
    let t: Key = self.key
    let t1: Key = other.key
    if t<t1 {
      //<t,T,s U <t1, T1, s1>>
      //result.factory.makeNode(key: t, take: self.take, skip: self.skip union other)

    } else if t==t1 {
      //<t,T U T1,s U s1>
      //result.factory.makeNode(key: t, take: self.take union other.take, skip: self.skip union other.skip)

    } else if t>t1 {
      // <t1,T1,s1 U <t, T, s>>
      //result.factory.makeNode(key: t1, take: other.take, skip: other.skip union self)
    }

    return result
  }
  
  
  /// Returns the intersection of this SFDD with another one.
  public func intersection(_ other: SFDD) -> SFDD {
    if self.isZero || (self === other) {
      return self
    } else if other.isZero {
      return other
    }
    
    // Remove '= self.factory.zero' when you will compute result in TODO part
    let result: SFDD = self.factory.zero
    
    // TODO
    let t: Key = self.key
    let t1: Key = other.key
    if t<t1 {
      // s N <t1, T1, s1>
      //result = self.skip intersection other

    } else if t==t1 {
      //make node <t,T N T1,s N s1>
      //result.factory.makeNode(key: t, take: self.take intersection other.take, skip: self.skip intersection other.skip)

    } else if t>t1 {
      //make node s1 N <t, T, s>
      //result = self intersection other.skip
    }
    
    return result
  }
  
  
  /// Returns the result of subtracting another SFDD to this one.
  public func subtracting(_ other: SFDD) -> SFDD {
    if self.isZero || other.isZero {
      return self
    } else if (self === other) {
      return self.factory.zero
    }
    
    // Remove '= self.factory.zero' when you will compute result in TODO part
    let result: SFDD = self.factory.zero
    
    // TODO
    
    return result
  }

  
}
