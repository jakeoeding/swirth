import Testing
import SwirthCore

struct VirtualMachineCase {
    let input: [Instruction]
    let expected: Int
}

@Test
func push() throws {
    let vm = VirtualMachine()
    try vm.evaluate([.push(8)])
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == 8)
}

@Test
func dot() throws {
    var output = [Int]()
    let vm = VirtualMachine { output.append($0) }

    try vm.evaluate([.push(10), .dot])

    #expect(vm.stackDepth == 0)
    #expect(vm.stackTop == nil)
    #expect(output == [10])
}

@Test
func dup() throws {
    let vm = VirtualMachine()
    try vm.evaluate([.push(2), .dup])
    #expect(vm.stackSnapshot == [2, 2])
}

@Test
func add() throws {
    let vm = VirtualMachine()
    try vm.evaluate([.push(1), .push(2), .add])
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == 3)
}

@Test
func divide() throws {
    let vm = VirtualMachine()
    try vm.evaluate([.push(10), .push(2), .divide])
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == 5)
}

@Test
func divisionByZeroThrows() throws {
    let vm = VirtualMachine()
    #expect(throws: VirtualMachine.ExecutionError.divisionByZero) {
        try vm.evaluate([.push(1), .push(0), .divide])
    }
}

@Test(arguments: [
    VirtualMachineCase(input: [.push(1), .push(1), .equal], expected: BoolFlag.true.rawValue),
    VirtualMachineCase(input: [.push(1), .push(0), .equal], expected: BoolFlag.false.rawValue),
])
func equal(_ example: VirtualMachineCase) throws {
    let vm = VirtualMachine()
    try vm.evaluate(example.input)
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == example.expected)
}

@Test(arguments: [
    VirtualMachineCase(input: [.push(1), .push(0), .notEqual], expected: BoolFlag.true.rawValue),
    VirtualMachineCase(input: [.push(1), .push(1), .notEqual], expected: BoolFlag.false.rawValue),
])
func notEqual(_ example: VirtualMachineCase) throws {
    let vm = VirtualMachine()
    try vm.evaluate(example.input)
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == example.expected)
}

@Test(arguments: [
    VirtualMachineCase(input: [.push(1), .push(0), .greaterThan], expected: BoolFlag.true.rawValue),
    VirtualMachineCase(input: [.push(0), .push(1), .greaterThan], expected: BoolFlag.false.rawValue),
])
func greaterThan(_ example: VirtualMachineCase) throws {
    let vm = VirtualMachine()
    try vm.evaluate(example.input)
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == example.expected)
}

@Test(arguments: [
    VirtualMachineCase(input: [.push(1), .push(0), .greaterThanOrEqual], expected: BoolFlag.true.rawValue),
    VirtualMachineCase(input: [.push(1), .push(1), .greaterThanOrEqual], expected: BoolFlag.true.rawValue),
    VirtualMachineCase(input: [.push(0), .push(1), .greaterThanOrEqual], expected: BoolFlag.false.rawValue),
])
func greaterThanOrEqual(_ example: VirtualMachineCase) throws {
    let vm = VirtualMachine()
    try vm.evaluate(example.input)
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == example.expected)
}

@Test(arguments: [
    VirtualMachineCase(input: [.push(0), .push(1), .lessThan], expected: BoolFlag.true.rawValue),
    VirtualMachineCase(input: [.push(1), .push(0), .lessThan], expected: BoolFlag.false.rawValue),
])
func lessThan(_ example: VirtualMachineCase) throws {
    let vm = VirtualMachine()
    try vm.evaluate(example.input)
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == example.expected)
}

@Test(arguments: [
    VirtualMachineCase(input: [.push(0), .push(1), .lessThanOrEqual], expected: BoolFlag.true.rawValue),
    VirtualMachineCase(input: [.push(1), .push(1), .lessThanOrEqual], expected: BoolFlag.true.rawValue),
    VirtualMachineCase(input: [.push(1), .push(0), .lessThanOrEqual], expected: BoolFlag.false.rawValue),
])
func lessThanOrEqual(_ example: VirtualMachineCase) throws {
    let vm = VirtualMachine()
    try vm.evaluate(example.input)
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == example.expected)
}

@Test
func multiply() throws {
    let vm = VirtualMachine()
    try vm.evaluate([.push(10), .push(2), .multiply])
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == 20)
}

@Test
func subtract() throws {
    let vm = VirtualMachine()
    try vm.evaluate([.push(9), .push(5), .subtract])
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == 4)
}

@Test
func swap() throws {
    let vm = VirtualMachine()
    try vm.evaluate([.push(1), .push(2), .swap])
    #expect(vm.stackSnapshot == [2, 1])
}

@Test
func drop() throws {
    let vm = VirtualMachine()
    try vm.evaluate([.push(1), .drop])
    #expect(vm.stackDepth == 0)
    #expect(vm.stackTop == nil)
}

@Test
func lshift() throws {
    let vm = VirtualMachine()
    try vm.evaluate([.push(9), .push(1), .lshift])
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == 18)
}

@Test
func rshift() throws {
    let vm = VirtualMachine()
    try vm.evaluate([.push(16), .push(1), .rshift])
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == 8)
}

@Test(arguments: [
    VirtualMachineCase(input: [.push(0), .push(1), .min], expected: 0),
    VirtualMachineCase(input: [.push(1), .push(0), .min], expected: 0),
])
func min(_ example: VirtualMachineCase) throws {
    let vm = VirtualMachine()
    try vm.evaluate(example.input)
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == example.expected)
}

@Test(arguments: [
    VirtualMachineCase(input: [.push(0), .push(1), .max], expected: 1),
    VirtualMachineCase(input: [.push(1), .push(0), .max], expected: 1),
])
func max(_ example: VirtualMachineCase) throws {
    let vm = VirtualMachine()
    try vm.evaluate(example.input)
    #expect(vm.stackDepth == 1)
    #expect(vm.stackTop == example.expected)
}

@Test
func peekingThrows() {
    let vm = VirtualMachine()
    #expect(throws: VirtualMachine.ExecutionError.stackUnderflow) {
        try vm.evaluate([.dup])
    }
}

@Test
func poppingThrows() {
    let vm = VirtualMachine()
    #expect(throws: VirtualMachine.ExecutionError.stackUnderflow) {
        try vm.evaluate([.drop])
    }
}

@Test
func poppingTwoThrows() {
    let vm = VirtualMachine()
    #expect(throws: VirtualMachine.ExecutionError.stackUnderflow) {
        try vm.evaluate([.push(1), .add])
    }
}
