extension SFDD: Sequence {
  
  public func makeIterator() -> AnyIterator<Set<Key>> {
    // Implementation note: The iteration process sees the DD as a tree, and explores all his
    // nodes with a in-order traversal. During this traversal, we store all the keys of the
    // "take" parents, so that we can produce an item whenever we reach the one terminal.
    var stack        : [SFDD] = []
    var node         : SFDD!  = self
    var partialResult: [Key] = []
    
    return AnyIterator {
      guard node != nil else { return nil }
      
      while !node.isZero {
        if node.isOne {
          let result = Set(partialResult)
          node = stack.popLast()
          if node != nil {
            partialResult = partialResult.filter({ $0 < node.key })
            node = node.skip
          }
          
          return result
        } else if !node.skip.isZero {
          stack.append(node)
        }
        partialResult.append(node.key)
        node = node.take
      }
      
      return nil
    }
  }
  
}

// Nice print
extension SFDD: CustomStringConvertible {
  
  public var description: String {
    let contentDescription = self
      .map({ element in
        "{" + element.map({ String(describing: $0) }).joined(separator: ", ") + "}"
      })
      .joined(separator: ", ")
    return "{\(contentDescription)}"
  }
  
}

// Nice print
extension SFDD: CustomDebugStringConvertible {
  
  public var debugDescription: String {
    return self.makeDebugDescription(indent: 0).joined(separator: "\n")
  }
  
  private func makeDebugDescription(indent: Int) -> [String] {
    if self.isZero {
      return ["⊥"]
    } else if self.isOne {
      return ["⊤"]
    }
    
    let prefix = String(repeating: " ", count: indent)
    var result = ["\(self.key!) -> ("]
    
    let takeDescription = self.take.makeDebugDescription(indent: indent + 2)
    result += [prefix + "  take: " + takeDescription[0]]
    result += takeDescription.dropFirst()
    
    let skipDescription = self.skip.makeDebugDescription(indent: indent + 2)
    result += [prefix + "  skip: " + skipDescription[0]]
    result += skipDescription.dropFirst()
    
    result += [prefix + ")"]
    return result
  }
}
