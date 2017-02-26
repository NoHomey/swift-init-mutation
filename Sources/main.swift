func strike(_ array: [Int], from: [Int]) -> [Int] {
    var result: Array<Int> = []

    for element in from {
        if array.index(of: element) == nil {
            result.append(element)
        }
    }

    return result
}

func mutations(count: Int, numbers: [Int]) -> [[Int]] {
    let start = numbers.count - count + 1
    let length = (start...(numbers.count)).reduce(1, {x, y in x * y})
    var repeats = Array<Int>(repeating: length / numbers.count, count: count)
    var divisor = numbers.count
    for i in 1..<count {
        divisor -= 1
        repeats[i] = repeats[i - 1] / divisor
    }
    var result = Array<Array<Int>>(repeating: [], count: length)
    var k = 0
    for i in 0..<count {
        k = 0
        while k < length {
            for number in strike(result[k], from: numbers) {
                for _ in 0..<repeats[i] {
                    result[k].append(number)
                    k += 1
                }
            }
        }
    }

    return result
}

func property(member: String) -> String {
    var result = ""
    for char in member.characters {
        if char == ":" {
            break
        }
        result.append(char)
    }

    return result
}


func generate(type: String, name: String, members: [String]) {
    print()
    print("\(type) \(name) {")
    for member in members {
        print("\tvar \(member)? = nil")
    }
    let numbers = Array<Int>(0..<members.count)
    for c in 1...members.count {
        let indexes = mutations(count: c, numbers: numbers)
        for index in indexes {
            print()
            print("\tinit(", terminator:"")
            for i in 0..<index.count {
                print(members[index[i]], terminator:"")
                if i + 1 < index.count {
                    print(", ", terminator:"")
                }
            } 
            print(") {")
            for i in index {
                let member = property(member: members[i])
                print("\t\tself.\(member) = \(member)")
            }
            print("\t}")
        }
    }
    
    print("}")
}

let type = CommandLine.arguments[1]
let name = CommandLine.arguments[2]
let members = CommandLine.arguments.dropFirst(3).sorted()

generate(type: type, name: name, members: Array(members))