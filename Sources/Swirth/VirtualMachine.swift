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

        func performOperation(_ op: Operation) throws {
            switch op {
                case .add:
                    guard
                        let rhs = stack.popLast() as? Int,
                        let lhs = stack.popLast() as? Int
                    else {
                        throw ExecutionError.invalidStackOperation
                    }

                    stack.append(lhs + rhs)
                case .dot:
                    guard let value = stack.popLast() else {
                        throw ExecutionError.stackUnderflow
                    }

                    print(value)
            }
        }
    }
}
