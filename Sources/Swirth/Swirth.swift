@main
struct Swirth {
    static func main() {
        let vm = VirtualMachine()

        while let line = readLine() {
            do {
                let tokens = try Lexer.tokenize(line)
                try vm.evaluate(tokens)
                print("ok")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
