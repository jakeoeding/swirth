@main
struct Swirth {
    static func main() {
        let vm = VirtualMachine()

        while let line = readLine() {
            do {
                let tokens = try Lexer.tokenize(line)
                let instructions = Compiler.emitIR(tokens)
                try vm.evaluate(instructions)
                print("ok")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
