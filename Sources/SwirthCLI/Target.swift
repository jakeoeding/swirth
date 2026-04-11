import ArgumentParser

public enum Target: String, ExpressibleByArgument {
    case ir
    case asm
    case binary

    public init?(argument: String) {
        self.init(rawValue: argument)
    }
}
