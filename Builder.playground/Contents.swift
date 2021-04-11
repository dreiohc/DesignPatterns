import UIKit

//: Faceted Builder

class Person: CustomStringConvertible {
  // address
  var streetAddress = "", postCode = "", city = ""
  
  //employment
  var companyName = "", position = ""
  var annaulIncome = 0
  
  var description: String {
    return "I live at \(streetAddress), \(postCode), \(city). I work at \(companyName) as a \(position), earning \(annaulIncome)"
  }
}

class PersonBuilder {
  var person = Person()
  var lives: PersonAddressBuilder {
    return PersonAddressBuilder(person)
  }
  var works: PersonJobBuilder {
    return PersonJobBuilder(person)
  }
  
  func build() -> Person {
    return person
  }
}

class PersonAddressBuilder: PersonBuilder {
  internal init(_ person: Person) {
    super.init()
    self.person = person
  }
  
  func at(_ streetAddress: String) -> PersonAddressBuilder {
    person.streetAddress = streetAddress
    return self
  }
  
  func withPostCode(_ postCode: String) -> PersonAddressBuilder {
    person.postCode = postCode
    return self
  }
  
  func inCity(_ city: String) -> PersonAddressBuilder {
    person.city = city
    return self
  }
  
}

class PersonJobBuilder: PersonBuilder {
  internal init(_ person: Person) {
    super.init()
    self.person = person
  }
  
  func at(_ companyName: String) -> PersonJobBuilder {
    person.companyName = companyName
    return self
  }
  
  func asA(_ position: String) -> PersonJobBuilder {
    person.position = position
    return self
  }
  
  func earning(_ annualIncome: Int) -> PersonJobBuilder {
    person.annaulIncome = annualIncome
    return self
  }
  
}


func facetedBuilderSample() {
  let pb = PersonBuilder()
  let p = pb
    .lives.at("123 London Road")
          .inCity("London")
          .withPostCode("SW12BC")
    .works.at("Fabrikam")
    .asA("Engineer")
    .earning(123000)
    .build()
  print(p)
  
}

//facetedBuilderSample()


//: Builder Coding Exercise

class Field: CustomStringConvertible {
  
  var name: String
  var type: String
  init(_ name: String, _ type: String) {
    self.name = name
    self.type = type
  }
  
  var description: String {
    return "\(name): \(type)"
  }
  
}


class Class: CustomStringConvertible {
  
  var name = ""
  var fields = [Field]()
  
  var description: String {
    var s = ""
    s.append("class \(name) \n{\n")
    for f in fields {
      s.append("\(f)\n")
    }
    s.append("}\n")
    return s
  }
}

class CodeBuilder: CustomStringConvertible {
  
  private var theClass = Class()
  
  init(_ rootName: String) {
    theClass.name = rootName
  }
  
  func addField(calledName name: String, ofType type: String) -> CodeBuilder  {
    theClass.fields.append(Field(name, type))
    return self
  }
  
  var description: String {
    return theClass.description
  }
}

func builderCodingExercise() {
  let field = CodeBuilder("Person")
  field
    .addField(calledName: "name", ofType: "String")
    .addField(calledName: "age", ofType: "Int")
    .description
  
  print(field)
}

//builderCodingExercise()
