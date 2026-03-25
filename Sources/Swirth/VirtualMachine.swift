extension Swirth {
    final class VirtualMachine {
        enum ExecutionError: Error {
            case stackUnderflow
            case invalidStackOperation
        }

        var stack = [Int]()

        func evaluate(_ tokens: [ForthToken]) throws {
            for token in tokens {
                switch token {
                case .literal(let value):
                    switch value {
                        case .int(let i):
                            stack.append(i)
                        case .bool(let b):
                            stack.append(b.rawValue)
                    }
                case .word(let op):
                    try performOperation(op)
                }
            }
        }

        func performOperation(_ operation: Word) throws {
            switch operation {
                case .binary(let binop):
                    guard
                        let rhs = stack.popLast(),
                        let lhs = stack.popLast()
                    else {
                        throw ExecutionError.invalidStackOperation
                    }

                    switch binop {
                        case .add:
                            stack.append(lhs + rhs)
                        case .divide:
                            stack.append(lhs / rhs)
                        case .multiply:
                            stack.append(lhs * rhs)
                        case .subtract:
                            stack.append(lhs - rhs)
                        case .swap:
                            stack.append(rhs)
                            stack.append(lhs)
                    }
                case .unary(let unop):
                    guard let value = stack.popLast() else {
                        throw ExecutionError.stackUnderflow
                    }

                    switch unop {
                        case .dot:
                            print(value)
                        case .dup:
                            stack.append(value)
                            stack.append(value)
                    }
            }
        }
    }
}
