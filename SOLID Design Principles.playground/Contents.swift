import UIKit

//: Open-Closed Principle and Specification
//: Open for extension but closed for modification

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


//: Liskov Substitution Principle
//: Passing in subtype will not break the function. Square here derives from rectangle so the function is still working.

class Rectangle: CustomStringConvertible {
  var _width = 0
  var _height = 0
  
  var width: Int {
    get { return _width }
    set(value) { _width = value }
  }
  
  var height: Int {
    get { return _height }
    set(value) { _height = value }
  }
  
  init() {}
  init(_ width: Int, _ height: Int) {
    _width = width
    _height = height
  }
  
  var area: Int {
    return width * height }
  
  public var description: String {
    return "Width: \(width), height: \(height)" }
}

class Square: Rectangle {
  
  override var width: Int {
    get { return _width }
    set(value) {
      _width = value
      _height = value
    }
  }
  
  override var height: Int {
    get { return _height }
    set(value) {
      _width = value
      _height = value
    }
  }
}

func setAndMeasure(_ rc: Rectangle) {
  rc.width = 4
  rc.height = 3
  print("Expected area to be 12 but got \(rc.area)")
}

func liskovPrincipleSample() {
  let rc = Rectangle()
  setAndMeasure(rc)
  
  let sq = Square()
  setAndMeasure(sq)
  
}

//liskovPrincipleSample()


//: Interface Segregation Principle
//: Implementing a large protocol but what if a certain class doesn't need all functions defined inside that protocol? Ans. Split the protocol.

protocol Printer {
  func print(d: Document)
}

protocol Scanner {
  func scan(d: Document)
}

protocol Fax {
  func fax(d: Document)
}

class OrdinaryPrinter: Printer {
  func print(d: Document) {
  }
}

class Document: Printer, Scanner {
  func print(d: Document) {
    // ok
  }
  
  func scan(d: Document) {
    // ok
  }
}

protocol MultiFunctionDevice: Printer, Scanner, Fax {}


class MultiFunctionMachine: MultiFunctionDevice {
  
  let printer: Printer
  let scanner: Scanner
  
  init(printer: Printer, scanner: Scanner) {
    self.printer = printer
    self.scanner = scanner
  }
  
  func print(d: Document) {
    printer.print(d: d) // Decorator Pattern
  }
  
  func scan(d: Document) {
    scanner.scan(d: d)
  }
  
  func fax(d: Document) {
    
  }
}

//: Dependency Inversion Principle
//: High-level module should not depend on low-level module but both should depend on abstractions. Abstraction should not depend on details but details should depend on abstractions.
enum Relationship {
  case parent
  case child
  case sibling
}

class Person {
  var name = ""
  init(_ name: String) {
    self.name = name
  }
}

protocol RelationshipBrowser {
  func findAllChildrenOf(_ name: String) -> [Person]
}

class Relationships: RelationshipBrowser {

  // low-level module
  private var relations = [(Person, Relationship, Person)]()
  
  func addParentAndChild(_ p: Person, _ c: Person) {
    relations.append((p, .parent, c))
    relations.append((c, .child, p))
  }
  
  func findAllChildrenOf(_ name: String) -> [Person] {
    return relations.filter{ $0.name == name && $1 == .parent && $2 === $2 }.map{ $2 }
  }
}

class Research { // high-level module

  init(_ browser: RelationshipBrowser) {
    for p in browser.findAllChildrenOf("John") {
      print("John has a child \(p.name)")
    }
  }
  
}

func dependencyInversionPrincipleSample() {
  let parent = Person("John")
  let child1 = Person("Chris")
  let child2 = Person("Matt")
  
  let relationships = Relationships()
  relationships.addParentAndChild(parent, child1)
  relationships.addParentAndChild(parent, child2)
  
  let _ = Research(relationships)
}

//dependencyInversionPrincipleSample()

