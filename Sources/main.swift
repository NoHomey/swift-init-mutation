func unique(array: [[Int]]) -> [[Int]] {
    var result = [array[0]]
    for i in 1..<array.count {
        var isFound = false
        for element in result {
            if element.count == array[i].count {
                for j in 0..<element.count {
                    if element[j] != array[i][j] {
                        break
                    }
                    if j + 1 == element.count {
                        isFound = true
                    }
                }
                if isFound {
                    break
                }
            }
        }
        if !isFound {
            result.append(array[i])
        }
    }

    return result
}

func mutations(count: Int, numbers: Int) -> [[Int]] {
    if count == 1 {
        var result: Array<Array<Int>> = []
        for i in 0..<numbers {
            result.append([i])
        }

        return result
    }
    let start = numbers - count + 1
    let length = (start...numbers).reduce(1, {x, y in x * y})
    var result = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: count), count: length)
    var j = count
    var v = 0
    var k = 0
    while j > 0 {
        k = 0
        v = 0
        for i in 0..<length {
            if(k == j) {
                k = 0
                v += 1
                if(v == numbers) {
                    v = 0
                }
            }
            if(result[i].index(of: v) == nil) {
                result[i][j - 1] = v   
            }
            k += 1
        }
        j -= 1
    }
    result[0][0] = numbers - 1
    
    return unique(array: result.map { arr in
        let index = arr.index(of: 0)
        if index == nil {
            return arr
        }
        var transform: Array<Int> = []
        for i in 0...index! {
            transform.append(arr[i])
        }
        if index! + 1 < count {
            for i in (index! + 1)..<count {
                if arr[i] != 0 {
                    transform.append(arr[i])
                }
            }
        }

        return transform
    }).filter { $0.count == count }
}

func property(member: String) -> String {
    var result = ""
    for c in member.characters {
        if c == ":" {
            break
        }
        result.append(c)
    }

    return result
}


func generate(type: String, name: String, members: [String]) {
    print()
    print("\(type) \(name) {")
    for member in members {
        print("\tvar \(member)? = nil")
    }
    for c in 1...members.count {
        let indexes = mutations(count: c, numbers: members.count)
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