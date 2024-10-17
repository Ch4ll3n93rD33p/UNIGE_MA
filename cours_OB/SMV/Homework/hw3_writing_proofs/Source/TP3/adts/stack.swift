import SwiftKanren

public class Stack : ADT {
  public init() {
    super.init("stack")
    self.add_generator("empty", Stack.empty)
    self.add_generator("cons", Stack.cons, arity:2)
    self.add_operator("pop", Stack.pop,[
      Rule(
        Stack.pop(Stack.empty()),
        Stack.empty()
      ),
      Rule(
        Stack.pop(Stack.cons(Variable(named: "n"),  Variable(named: "rest"))),
        Variable(named: "rest")
      )
    ],["stack"])
    self.add_operator("top", Stack.top, [
      Rule(
        Stack.top(Stack.empty()),
        vFail
      ),
      Rule(
        Stack.top(Stack.cons(Variable(named: "n"), Variable(named: "rest"))),
        Variable(named: "n")
      )
    ],["stack"])
    self.add_operator("size", Stack.size, [
      Rule(
        Stack.size(Stack.empty()),
        Nat.zero()
      ),
      Rule(
        Stack.size(Stack.cons(Variable(named: "n"), Variable(named: "rest"))),
        Nat.succ(Stack.size(Variable(named: "rest")))
      )
    ], ["stack"])
  }

  public static func empty(_:Term...)->Term{
    return new_term(Value("empty"),"stack")
  }

  public static func cons(_ terms: Term...) -> Term{
    return new_term(Map([
      "first": terms[0],
      "rest": terms[1]
      ]), "stack")
  }
  
  public class func n(_ terms: [Term]) -> Term{
    if terms.count == 0 {
      return Stack.empty()
    }
    return Stack.cons(terms[0],Stack.n(Array<Term>(terms.dropFirst())))
  }
  
  public static func pop(_ t: Term...)->Term{
    return Operator.n("pop",t[0])
  }

  public static func size(_ t: Term...)->Term{
    return Operator.n("size",t[0])
  }
  
  public static func top(_ t: Term...)->Term{
    return Operator.n("top",t[0])
  }

  public class override func belong(_ x: Term) -> Goal{
    return (x === Stack.empty() || delayed(fresh{y in fresh{z in x === Stack.cons(y,z) && Nat.belong(y) && Stack.belong(z)}}))
  }
  
  public override func pprint(_ t: Term) -> String{
    var s : String = "["
    var x = t
    var i = 0
    while !x.equals(Stack.empty()){
      if i>0{
        if let xm = x as? Map {
          if let name = xm["name"] {
            if "\(name)" != "pop" {
              s += ", "
            }
          }
        } else  {
          s += ", "
        }
      }
      if let v = (x as? Variable){
        s += v.name
        x = Stack.empty()
      }
      else if let m = (value(x) as? Map){
        s += "\(ADTm.pprint(m["first"]!))"
        x = m["rest"]!
      } else {
        x = Stack.empty()
      }
      i += 1
    }
    return s + "]"
  }

}
