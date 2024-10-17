import SwiftKanren

//// SET
//// https://en.wikipedia.org/wiki/Set_(abstract_data_type)
public class Set : ADT {
  public init(){
    super.init("set")

    self.add_generator("empty", Set.empty)
    self.add_generator("cons", Set.cons, arity:2)

    self.add_operator("contains", Set.contains, [
      Rule(Set.contains(Set.empty(), Variable(named: "x")), Boolean.False()), // contains({},x) -> False
      Rule(
              Set.contains(Set.cons(Variable(named: "x"), Variable(named: "set")), Variable(named: "x")),
              Boolean.True()
      ), // contains({x,...},x) -> True
      Rule(
              Set.contains(Set.cons(Variable(named: "x"), Variable(named: "set")), Variable(named: "y")),
              Set.contains(Variable(named: "set"), Variable(named: "y"))
      ) // contains({x,set},y) -> contains(set,y)
      ], ["set", "any"])

    self.add_operator("removeOne", Set.removeOne,[
      Rule(
              Set.removeOne(Variable(named: "set"), Variable(named: "x")),
              Variable(named: "set"),
              Boolean.not(Set.contains(Variable(named: "set"), Variable(named: "x")))
      ), // case !contains(set,x) : removeOne(set,x) = set
      Rule(
              Set.removeOne(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "x")),
              Variable(named: "rest")
      ), // removeOne({x,rest},x) = rest
      Rule(
              Set.removeOne(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "y")),
              Set.cons(Variable(named: "x"), Set.removeOne(Variable(named: "rest"), Variable(named: "y")))
      ) // removeOne({x,rest},y) = {x,removeOne(rest,y)}
      ], ["set", "any"])

    self.add_operator("==", Set.eq,[
      Rule(Set.eq(Set.empty(), Set.empty()), Boolean.True()), // {}=={} -> True
      Rule(
              Set.eq(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "set2")),
              Set.eq(Variable(named: "rest"), Set.removeOne(Variable(named: "set2"), Variable(named: "x"))),
              Set.contains(Variable(named: "set2"), Variable(named: "x"))
      ), // case contains(set2,x) : cons(x,rest)==set2 -> rest==removeOne(set2,x)
      Rule(
              Set.eq(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "set2")),
              Boolean.False(),
              Boolean.not(Set.contains(Variable(named: "set2"), Variable(named: "x")))
      ), // case !contains(set2,x) : cons(x,rest)==set2 -> False
      Rule(
              Set.eq(Variable(named: "set1"), Variable(named: "set2")),
              Boolean.False(),
              Boolean.not(Boolean.eq(Set.contains(Variable(named: "set1"), Variable(named: "x")), Set.contains(Variable(named: "set2"), Variable(named: "x"))))
      ) // case contains(set1,x) xor contains(set2,x) : set1==set2 -> False
      ], ["set", "set"])

    self.add_operator("insert", Set.insert, [
      Rule(Set.insert(Variable(named: "x"), Set.empty()), Set.cons(Variable(named: "x"), Set.empty())), // insert(x,{}) = {x}
      Rule(
              Set.insert(Variable(named: "x"), Variable(named: "set")),
              Variable(named: "set"),
              Set.contains(Variable(named: "set"), Variable(named: "x"))
      ), // case contains(set,x) : insert(x,set) = set
      Rule(
              Set.insert(Variable(named: "x"), Variable(named: "set")),
              Set.cons(Variable(named: "x"), Variable(named: "set"))
      ) // insert(x,{...}) = {x,...}
    ], ["any", "set"])

    self.add_operator("union", Set.union, [
      Rule(Set.union(Variable(named: "x"), Set.empty()), Variable(named: "x")), // union(x,{}) = {}
      Rule(Set.union(Set.empty(), Variable(named: "x")), Variable(named: "x")), // union({},x}) = {}
      Rule(
              Set.union(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "set2")),
              Set.cons(Variable(named: "x"), Set.union(Variable(named: "rest"), Set.removeOne(Variable(named: "set2"), Variable(named: "x"))))
      ) // union(cons(x,rest), set2) = cons(x,union(rest, removeOne(set2,x)))
      ], ["set", "set"])

    self.add_operator("intersection", Set.intersection, [
      Rule(Set.intersection(Variable(named: "x"), Set.empty()), Set.empty()), // intersection(x,{}) = {}
      Rule(Set.intersection(Set.empty(), Variable(named: "x")), Set.empty()), // intersection({},x}) = {}
      Rule(
              Set.intersection(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "set2")),
              Set.intersection(Variable(named: "rest"), Variable(named: "set2")),
              Boolean.not(Set.contains(Variable(named: "set2"), Variable(named: "x")))
      ), // case !contain(set2, x) : intersection(cons(x,rest), set2) = intersection(rest, set2)
    Rule(
            Set.intersection(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "set2")),
            Set.cons(Variable(named: "x"), Set.intersection(Variable(named: "rest"), Variable(named: "set2"))),
            Set.contains(Variable(named: "set2"), Variable(named: "x"))
    ) // case contain(set2, x) : intersection(cons(x,rest), set2) = cons(x,intersection(rest, set2))
      ], ["set", "set"])

    self.add_operator("diff", Set.diff, [
      Rule(Set.diff(Variable(named: "x"), Set.empty()), Variable(named: "x")), // diff(x,{}) = x
      Rule(Set.diff(Set.empty(), Variable(named: "x")), Set.empty()), // diff({},x}) = {}
      Rule(
            Set.diff(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "set2")),
            Set.cons(Variable(named: "x"), Set.diff(Variable(named: "rest"), Variable(named: "set2"))),
            Boolean.not(Set.contains(Variable(named: "set2"), Variable(named: "x")))
      ), // case !contain(set2, x) : diff(cons(x,rest), set2) = cons(x,diff(rest, set2))
      Rule(
            Set.diff(Set.cons(Variable(named: "x"), Variable(named: "rest")), Variable(named: "set2")),
            Set.diff(Variable(named: "rest"), Variable(named: "set2")),
            Set.contains(Variable(named: "set2"), Variable(named: "x"))
      ) // case contain(set2, x) : diff(cons(x,rest), set2) = diff(rest, set2)
      ], ["set", "set"])

    self.add_operator("subSet", Set.subSet, [
      Rule(
              Set.subSet(Variable(named: "set1"), Variable(named: "set2")),
              Set.eq(Variable(named: "set1"), Set.intersection(Variable(named: "set1"), Variable(named: "set2")))
      ) // subSet(set1,set2) -> eq(set1, intersection(set1, set2))
      ], ["set", "set"])

    self.add_operator("size", Set.size, [
      Rule(Set.size(Set.empty()), Nat.zero()), // size({}) = 0
      Rule(
              Set.size(Set.cons(Variable(named: "x"), Variable(named: "rest"))),
              Nat.succ(x: Set.size(Variable(named: "rest")))
      ) // size(cons(x,rest) = size(rest)+1
      ], ["set"])

  }
  public static func empty(_ :Term...) -> Term{
    return new_term(Value<String>("Set.tail"),"set")
  }

  public static func cons(_ terms: Term...) -> Term{
    return new_term(Map([
      "first": terms[0],
      "rest": terms[1]
      ]), "set")
  }

  public static func contains(_ terms: Term...)->Term{
    return Operator.n("contains", terms[0], terms[1] )
  }
  public static func size(_ terms: Term...)->Term{
    return Operator.n("size",terms[0])
  }

  public static func removeOne(_ terms: Term...)->Term{
    return Operator.n("removeOne",terms[0], terms[1])
  }

  public class func eq(_ terms: Term...)-> Term
  {
    return Operator.n("==",terms[0],terms[1])
  }

  public static func insert(_ terms: Term...)->Term{
    return Operator.n("insert",terms[0], terms[1])
  }

  public static func union(_ terms: Term...)->Term{
    return Operator.n("union", terms[0], terms[1])
  }

  public static func intersection(_ terms: Term...)->Term{
    return Operator.n("intersection", terms[0], terms[1])
  }

  public static func diff(_ terms: Term...)->Term{
    return Operator.n("diff", terms[0], terms[1])
  }

  public static func subSet(_ terms: Term...)->Term{
    return Operator.n("subSet",terms[0], terms[1])
  }

  public class override func belong(_ x: Term) -> Goal{
    return (x === Set.empty() || delayed(fresh {y in fresh{w in x === Set.cons(y,w) && Set.belong(w)}}))
  }

  public class func n(_ terms: [Term]) -> Term{
    let n = terms.count
    if n == 0 {
      return Set.empty()
    }
    return Set.insert(terms[0],Set.n(Array<Term>(terms.suffix(n-1))))
  }

  public override func pprint(_ t: Term) -> String{
    var s : String = "{"
    var x = t
    var i = 0
    while !x.equals(Set.empty()){
      if i>0{
        s += ", "
      }
      if let v = (x as? Variable){
        s += v.name
        x = Set.empty()
      }
      else if let m = (value(x) as? Map){
        s += ADTm.pprint(m["first"]!)
        x = m["rest"]!
      }else{
        x = Set.empty()
      }
      i += 1
    }
    return s + "}"
  }
}
