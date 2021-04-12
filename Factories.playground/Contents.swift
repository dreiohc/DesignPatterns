import UIKit

//: Factory Method

class Point: CustomStringConvertible {
  private var x, y: Double
  
  private init(x: Double, y: Double) { // Initializers can be set to private if the number of methods are not too big.
    self.x = x
    self.y = y
  }
  
  private init(rho: Double, theta: Double) {
    x = rho * cos(theta)
    y = rho * sin(theta)
  }
  
  static func createCartesian(x: Double, y: Double) -> Point { // Pros is it's more descriptive than just having an initializer.
    return Point(x: x, y: y)
  }
  
  static func createPolar(rho: Double, theta: Double) -> Point {
    return Point(rho: rho, theta: theta)
  }
  
  var description: String {
    return "x = \(x), y= \(y)"
  }
  
  static let factory = PointFactory.instance // Singleton
  
  class PointFactory { // Encapsulating methods
    
    private init() {}
    static let instance = PointFactory()
    
    func createCartesian(x: Double, y: Double) -> Point { // Pros is it's more descriptive than just having an initializer.
      return Point(x: x, y: y)
    }
    
    func createPolar(rho: Double, theta: Double) -> Point { // Theses methods can be static or instance methods.
      return Point(rho: rho, theta: theta)
    }
  }
}



func factorySample() {
  let nonSingleton = Point.createPolar(rho: 1, theta: 2)
  let singleton = Point.factory.createCartesian(x: 1, y: 2)
  
  print(nonSingleton)
  print(singleton)
  
}

// factorySample()


//: Abstract Factory

protocol HotDrink {
  func consume()
}

class Tea: HotDrink {
  func consume() {
    print("This tea is nice but I prefer it with milk.")
  }
}

class Coffee: HotDrink {
  func consume() {
    print("This coffee is delicious!")
  }
}


protocol HotDrinkFactory {
  init()
  func prepare(amount: Int) -> HotDrink
}

class TeaFactory {
  required init() {}
  
  func prepare(amount: Int) -> HotDrink {
    print("Put in tea bag, boil water, pour \(amount)ml, add lemon, enjoy")
    return Tea()
  }
  
}


class CoffeeFactory {
  required init() {
    func prepare(amount: Int) -> HotDrink {
      print("Grind some beans, boil water, pour \(amount)ml, add cream and sugar, enjoy!")
      return Coffee()
    }
  }
}


class HotDrinkMachine {
  enum AvailableDrink: String, CaseIterable { // breaks OCP
    case coffee = "Coffee"
    case tea = "Tea"
  }
  internal var factories = [AvailableDrink: HotDrinkFactory]()
  
  internal var namedFactories = [(String, HotDrinkFactory)]()
  
  init() {
    for drink in AvailableDrink.allCases {
      let type = NSClassFromString("demo.\(drink.rawValue)Factory")
      let factory = (type as! HotDrinkFactory.Type).init()
      factories[drink] = factory
      namedFactories.append((drink.rawValue, factory))
    }
  }
  
  func makeDrink() -> HotDrink {
    print("Available drinks:")
    for i in 0..<namedFactories.count {
      let tuple = namedFactories[i]
      print("\(i): \(tuple.0)")
    }
    let input = Int(readLine()!)!
    return namedFactories[input].1.prepare(amount: 250)
  }
}

func abstractFactorySample() {
  let machine = HotDrinkMachine()
  print(machine.namedFactories.count)
  let drink = machine.makeDrink()
  drink.consume()
}

//abstractFactorySample()

//: Factory Coding Exercise

class Person: CustomStringConvertible {
  
  var id: Int
  var name: String
  
  init(called name: String, with id: Int) {
    self.name = name
    self.id = id
  }
  
  var description: String {
    return "id: \(id), name: \(name)"
  }
}

class PersonFactory {
  
  private var id = 0
  
  func createPerson(name: String) -> Person {
    id += 1
    return Person(called: name, with: id)
  }
}


func factoryCodingExercise() {

  let f = PersonFactory()
  f.createPerson(name: "Myron")
  f.createPerson(name: "Sarah")
}

factoryCodingExercise()
