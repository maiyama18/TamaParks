public extension Park {
    convenience init(name: String, kana: String) {
        self.init()

        self.name = name
        self.kana = kana
    }

    var visited: Bool {
        visitedAt != nil
    }
}
