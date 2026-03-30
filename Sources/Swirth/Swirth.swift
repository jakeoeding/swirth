import ArgumentParser

@main
struct Swirth: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A minimal Forth implemented in Swift.",
        subcommands: [Interpret.self],
        defaultSubcommand: Interpret.self
    )
}
