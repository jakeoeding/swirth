@main
struct Swirth {
    static func main() {
        let vm = VirtualMachine()

        while let line = readLine() {
            do {
                let tokens = try Lexer.process(line)
                try vm.evaluate(tokens)
                print("ok")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
