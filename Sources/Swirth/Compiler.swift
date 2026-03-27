extension Swirth {
    enum Instruction {
        case push(Int)
        case dot
        case dup
        case add
        case divide
        case equal
        case greaterThan
        case greaterThanOrEqual
        case lessThan
        case lessThanOrEqual
        case multiply
        case subtract
        case swap
    }

    final class Compiler {
        enum CompilationError: Error {
            case invalidDefinitionTermination
            case undefinedWord(String)
        }

        var definitions = [String: [Instruction]]()

        func emitIR(_ tokens: [Token]) throws(CompilationError) -> [Instruction] {
            var outputStack: [[Instruction]] = [[]]

            var currentDefinition: String?
            var currentOutput: [Instruction] {
                get { outputStack[outputStack.count - 1] }
                set { outputStack[outputStack.count - 1] = newValue }
            }

            for token in tokens {
                switch token {
                case .literal(let value):
                    switch value {
                    case .int(let i):
                        currentOutput.append(.push(i))
                    case .bool(let b):
                        currentOutput.append(.push(b.rawValue))
                    }
                case .word(let op):
                    switch op {
                    case .dot:
                        currentOutput.append(.dot)
                    case .dup:
                        currentOutput.append(.dup)
                    case .add:
                        currentOutput.append(.add)
                    case .divide:
                        currentOutput.append(.divide)
                    case .equal:
                        currentOutput.append(.equal)
                    case .greaterThan:
                        currentOutput.append(.greaterThan)
                    case .greaterThanOrEqual:
                        currentOutput.append(.greaterThanOrEqual)
                    case .lessThan:
                        currentOutput.append(.lessThan)
                    case .lessThanOrEqual:
                        currentOutput.append(.lessThanOrEqual)
                    case .multiply:
                        currentOutput.append(.multiply)
                    case .subtract:
                        currentOutput.append(.subtract)
                    case .swap:
                        currentOutput.append(.swap)
                    }
                case .delimiter(let d):
                    switch d {
                    case .functionStart:
                        outputStack.append([])
                    case .functionEnd:
                        if currentDefinition == nil {
                            throw .invalidDefinitionTermination
                        }

                        definitions[currentDefinition!] = outputStack.removeLast()
                        currentDefinition = nil
                    }
                case .identifier(let id):
                    if currentDefinition == nil && outputStack.count > 1 {
                        currentDefinition = id
                        continue
                    }

                    guard let instructionsForId = definitions[id] else {
                        throw .undefinedWord(id)
                    }

                    currentOutput.append(contentsOf: instructionsForId)
                }
            }

            return outputStack.removeLast()
        }
    }
}
