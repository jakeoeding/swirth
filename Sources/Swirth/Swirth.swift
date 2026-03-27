@main
struct Swirth {
    static func main() {
        let vm = VirtualMachine()
        let compiler = Compiler()

        while let line = readLine() {
            do {
                let tokens = try Lexer.tokenize(line)
                let instructions = try compiler.emitIR(tokens)
                try vm.evaluate(instructions)
                print("ok")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
