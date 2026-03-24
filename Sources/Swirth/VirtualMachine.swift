extension Swirth {
    final class VirtualMachine {
        enum ExecutionError: Error {
            case stackUnderflow
            case invalidStackOperation
        }

        var stack = [Any]()

        func evaluate(_ tokens: [ForthToken]) throws {
            for token in tokens {
                switch token {
                case .literal(let value):
                    stack.append(value)
                case .operation(let op):
                    try performOperation(op)
                }
            }
        }

        func performOperation(_ operation: Operation) throws {
            switch operation {
                case .binary(let binop):
                    guard
                        let rhs = stack.popLast() as? Int,
                        let lhs = stack.popLast() as? Int
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
                    }
                case .dot:
                    guard let value = stack.popLast() else {
                        throw ExecutionError.stackUnderflow
                    }

                    print(value)
            }
        }
    }
}
