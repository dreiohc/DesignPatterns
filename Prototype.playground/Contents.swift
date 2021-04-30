



//: Useful for Replication of instances. Cons would take a lot of work if you have a lot of objects.

import UIKit

func header(_ title: String) {
    print("\n\n")
    print("---------------------------------------------------------------------------------------------")
    print("                                           \(title)                                          ")
    print("---------------------------------------------------------------------------------------------")
}


header("Copying from initializer")

protocol Copying {
    init(copyFrom other: Self)
}

class Address: CustomStringConvertible, Copying {
    
    var streetAddress: String
    var city: String
    
    init(_ streetAddress: String, _ city: String) {
        self.streetAddress = streetAddress
        self.city = city
    }
    
    required init(copyFrom other: Address) {
        streetAddress = other.streetAddress
        city = other.city
    }
    
    
    var description: String {
        return "\(streetAddress), \(city)"
    }
}

class Employee: CustomStringConvertible {
    var name: String
    var address: Address
    
    init(_ name: String, _ address: Address) {
        self.name = name
        self.address = address
    }
    
    init(copyFrom other: Employee) {
        name = other.name
        address = Address(copyFrom: other.address)
    }
    
    var description: String {
        return "My name is \(name) and I live at \(address)"
    }
}

func main0() {
    let john = Employee("John", Address("123 London Road", "London"))
    /* var chris = john  --  if you do this both john and chris instances will be both "chris" unless you convert class Employee into struct.
     chris.name = "Chris" */
    
    let chris = Employee(copyFrom: john)
    chris.name = "Chris"
    chris.address.streetAddress = "124 London Road"
    print(john.description)
    print(chris.description)
}

main0()

header("Clone using generics")

protocol Copying1 {
    func clone() -> Self
}

class Address1: CustomStringConvertible, Copying1 {
    
    var streetAddress: String
    var city: String
    
    init(_ streetAddress: String, _ city: String) {
        self.streetAddress = streetAddress
        self.city = city
    }
    
    required init(copyFrom other: Address1) {
        streetAddress = other.streetAddress
        city = other.city
    }
    
    var description: String {
        return "\(streetAddress), \(city)"
    }
    
    func clone() -> Self {
        return cloneImpl()
    }
    
    private func cloneImpl<T>() -> T {
        return Address1(streetAddress, city) as! T
    }
}

class Employee1: CustomStringConvertible {
    var name: String
    var address: Address1
    
    init(_ name: String, _ address: Address1) {
        self.name = name
        self.address = address
    }
    
    init(copyFrom other: Employee1) {
        name = other.name
        address = Address1(copyFrom: other.address)
    }
    
    var description: String {
        return "My name is \(name) and I live at \(address)"
    }
    
    func clone() -> Employee1 {
        return Employee1(name, address.clone())
    }
}

func main1() {
    let john = Employee1("John", Address1("123 London Road", "London"))
    /* var chris = john  --  if you do this both john and chris instances will be both "chris" unless you convert class Employee into struct.
     chris.name = "Chris" */
    
    let chris = john.clone()
    chris.name = "Chris"
    chris.address.streetAddress = "124 London Road"
    print(john.description)
    print(chris.description)
}

main1()

// MARK: - Exercise

header("Exercise")

class Point
{
  var x = 0
  var y = 0

  init() {}

  init(x: Int, y: Int)
  {
    self.x = x
    self.y = y
  }
}

class Line: CustomStringConvertible
{
  var start = Point()
  var end = Point()

  init(start: Point, end: Point)
  {
    self.start = start
    self.end = end
  }

  func deepCopy() -> Line
  {
    let newStart = Point(x: start.x, y: start.y)
    let newEnd = Point(x: end.x, y: end.y)
    return Line(start: newStart, end: newEnd)
  }
    
    var description: String {
        return "start x: \(start.x), start y: \(end.x)\nstart y: \(start.y), end y: \(end.y)"
    }
}

func exercise() {
    let start = Point(x: 1, y: 2)
    let end = Point(x: 3, y: 4)
    let origin = Line(start: start, end: end)
    
    let newCoordinates = Point(x: 6, y: 7)
    let stop = Point(x: 8, y: 9)
    let detour = Line(start: newCoordinates, end: stop)
    
    let destination = Line.deepCopy(detour)
    
    print(origin.description)
    print(destination().description)
}

exercise()
