extension Swirth {
    final class VirtualMachine {
        var stack = [Int]()

        func evaluate(_ instructions: [Instruction]) throws(ExecutionError) {
            for instruction in instructions {
                switch instruction {
                case .push(let i):
                    stack.append(i)
                case .dot:
                    print(try pop())
                case .dup:
                    let top = try peek()
                    stack.append(top)
                case .add:
                    let (lhs, rhs) = try pop2()
                    stack.append(lhs + rhs)
                case .divide:
                    let (numerator, denominator) = try pop2()

                    if denominator == 0 {
                        throw .divisionByZero
                    }

                    stack.append(numerator / denominator)
                case .equal:
                    let (lhs, rhs) = try pop2()
                    stack.append(BoolFlag.from(lhs == rhs).rawValue)
                case .notEqual:
                    let (lhs, rhs) = try pop2()
                    stack.append(BoolFlag.from(lhs != rhs).rawValue)
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
                    let (a, b) = try pop2()
                    stack.append(b)
                    stack.append(a)
                case .drop:
                    _ = try pop()
                case .lshift:
                    let (x, n) = try pop2()
                    stack.append(x << n)
                case .rshift:
                    let (x, n) = try pop2()
                    stack.append(x >> n)
                case .max:
                    let (a, b) = try pop2()
                    stack.append(max(a, b))
                case .min:
                    let (a, b) = try pop2()
                    stack.append(min(a, b))
                }
            }
        }

        private func peek() throws(ExecutionError) -> Int {
            guard let top = stack.last else {
                throw .stackUnderflow
            }

            return top
        }

        private func pop() throws(ExecutionError) -> Int {
            guard let top = stack.popLast() else {
                throw .stackUnderflow
            }

            return top
        }

        private func pop2() throws(ExecutionError) -> (Int, Int) {
            guard
                let top = stack.popLast(),
                let next = stack.popLast()
            else {
                throw .stackUnderflow
            }

            return (next, top)
        }
    }
}

extension Swirth.VirtualMachine {
    enum ExecutionError: Error {
        case divisionByZero
        case stackUnderflow
    }
}
