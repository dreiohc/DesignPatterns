import UIKit

//: Open-Closed Principle and Specification

enum Color {
  case red
  case blue
  case green
}

enum Size {
  case small
  case medium
  case large
  case huge
}

class Product {
  var name: String
  var color: Color
  var size: Size
  
  init(_ name: String,
       _ color: Color,
       _ size: Size)
  {
    self.name = name
    self.color = color
    self.size = size
  }
}

protocol Specificiation {
  associatedtype T
  func isSatisfied(_ item: T) -> Bool
}

protocol Filter {
  associatedtype T
  func filter<Spec: Specificiation>(_ item: [T], _ spec: Spec) -> [T]
  where Spec.T == T
}


class ColorSpecification: Specificiation {
  
  let color: Color
  
  init(_ color: Color) {
    self.color = color
  }
  
  func isSatisfied(_ item: Product) -> Bool {
    return item.color == color
  }
}

class BetterFilter: Filter {
  
  typealias T = Product
  
  var result = [Product]()
  
  func filter<Spec: Specificiation>(_ item: [Product], _ spec: Spec) -> [Product] where Spec.T == Product {
    for i in item {
      if spec.isSatisfied(i) {
        result.append(i)
      }
    }
    return result
  }
}

class SizeSpecification: Specificiation {
  
  let size: Size
  
  init(_ size: Size) {
    self.size = size
  }
  
  func isSatisfied(_ item: Product) -> Bool {
    return item.size == size
  }
}


class AndSpecification<T,
                       SpecA: Specificiation,
                       SpecB: Specificiation>: Specificiation where T == SpecA.T,
                                                                    SpecA.T == SpecB.T {

  let specA: SpecA
  let specB: SpecB
  
  init(_ first: SpecA, _ second: SpecB) {
    self.specA = first
    self.specB = second
  }
  
  func isSatisfied(_ item: T) -> Bool {
    return specA.isSatisfied(item) && specB.isSatisfied(item)
  }
}


func openClosePrincipleSample() {
  
  let apple = Product("Apple", .red, .small)
  let tree = Product("Tree", .green, .large)
  let house = Product("House", .blue, .large)
  
  let products = [apple, tree, house]
  
  let bf = BetterFilter()
  print("Green products:")
  for p in bf.filter(products, ColorSpecification(.green)) {
    print("- \(p.name) is green")
  }
  
  print("Large blue items")
  for p in bf.filter(products, AndSpecification(ColorSpecification(.blue), SizeSpecification(.large))) {
    print("- \(p.name) is large and blue")
  }
}

//openClosePrincipleSample()


