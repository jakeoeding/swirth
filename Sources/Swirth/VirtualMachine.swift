extension Swirth {
    final class VirtualMachine {
        enum ExecutionError: Error {
            case stackUnderflow
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
                case .dot:
                    print(try pop())
                case .dup:
                    let top = try pop()
                    stack.append(top)
                    stack.append(top)
                case .add:
                    let (lhs, rhs) = try pop2()
                    stack.append(lhs + rhs)
                case .divide:
                    let (lhs, rhs) = try pop2()
                    stack.append(lhs / rhs)
                case .equal:
                    let (lhs, rhs) = try pop2()
                    stack.append(BoolFlag.from(lhs == rhs).rawValue)
                case .greaterThan:
                    let (lhs, rhs) = try pop2()
                    stack.append(BoolFlag.from(lhs > rhs).rawValue)
                case .greaterThanOrEqual:
                    let (lhs, rhs) = try pop2()
                    stack.append(BoolFlag.from(lhs >= rhs).rawValue)
                case .lessThan:
                    let (lhs, rhs) = try pop2()
                    stack.append(BoolFlag.from(lhs < rhs).rawValue)
                case .lessThanOrEqual:
                    let (lhs, rhs) = try pop2()
                    stack.append(BoolFlag.from(lhs <= rhs).rawValue)
                case .multiply:
                    let (lhs, rhs) = try pop2()
                    stack.append(lhs * rhs)
                case .subtract:
                    let (lhs, rhs) = try pop2()
                    stack.append(lhs - rhs)
                case .swap:
                    let (lhs, rhs) = try pop2()
                    stack.append(rhs)
                    stack.append(lhs)
            }
        }

        private func pop() throws -> Int {
            guard let top = stack.popLast() else {
                throw ExecutionError.stackUnderflow
            }

            return top
        }

        private func pop2() throws -> (Int, Int) {
            guard
                let rhs = stack.popLast(),
                let lhs = stack.popLast()
            else {
                throw ExecutionError.stackUnderflow
            }

            return (lhs, rhs)
        }
    }
}
