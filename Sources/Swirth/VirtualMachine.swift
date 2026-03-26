extension Swirth {
    final class VirtualMachine {
        enum ExecutionError: Error {
            case divisionByZero
            case stackUnderflow
        }

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
                let rhs = stack.popLast(),
                let lhs = stack.popLast()
            else {
                throw .stackUnderflow
            }

            return (lhs, rhs)
        }
    }
}
