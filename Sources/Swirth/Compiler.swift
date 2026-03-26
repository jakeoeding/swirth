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

    struct Compiler {
        static func emitIR(_ tokens: [Token]) -> [Instruction] {
            var instructions = [Instruction]()

            for token in tokens {
                switch token {
                case .literal(let value):
                    switch value {
                    case .int(let i):
                        instructions.append(.push(i))
                    case .bool(let b):
                        instructions.append(.push(b.rawValue))
                    }
                case .word(let op):
                    switch op {
                    case .dot:
                        instructions.append(.dot)
                    case .dup:
                        instructions.append(.dup)
                    case .add:
                        instructions.append(.add)
                    case .divide:
                        instructions.append(.divide)
                    case .equal:
                        instructions.append(.equal)
                    case .greaterThan:
                        instructions.append(.greaterThan)
                    case .greaterThanOrEqual:
                        instructions.append(.greaterThanOrEqual)
                    case .lessThan:
                        instructions.append(.lessThan)
                    case .lessThanOrEqual:
                        instructions.append(.lessThanOrEqual)
                    case .multiply:
                        instructions.append(.multiply)
                    case .subtract:
                        instructions.append(.subtract)
                    case .swap:
                        instructions.append(.swap)
                    }
                }
            }

            return instructions
        }
    }
}
