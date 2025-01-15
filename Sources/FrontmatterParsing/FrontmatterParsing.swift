// The Swift Programming Language
// https://docs.swift.org/swift-book

//
//  MarkdownWithFrontMatterConversion.swift
//  OpenFestival
//
//  Created by Woodrow Melling on 10/25/24.
//

import Parsing
import Conversions
import Foundation


public struct MarkdownWithFrontMatter<FrontMatter> {
    public init(frontMatter: FrontMatter? = nil, body: String? = nil) {
        self.frontMatter = frontMatter
        self.body = body
    }

    public var frontMatter: FrontMatter?
    public var body: String?
}

extension MarkdownWithFrontMatter: Equatable where FrontMatter: Equatable {}

extension MarkdownWithFrontMatter {
    public struct Parser: Parsing.Parser, ParserPrinter where FrontMatter: Codable {
        public typealias Input = Substring
        public typealias Output = MarkdownWithFrontMatter

        public var body: some ParserPrinter<Input, Output> {
            ParsePrint(.memberwise(MarkdownWithFrontMatter.init(frontMatter:body:))) {
                Optionally {
                    Parsers.FrontMatter<FrontMatter>()
                    Whitespace(1, .vertical)
                }

                Optionally {
                    Rest().map(.string)
                }

            }
        }
    }
}

extension Parsers {
    public struct FrontMatter<FrontMatter: Codable>: ParserPrinter {
        public typealias Input = Substring

        // We need to be careful here, because we want to parse everything between the delimiters as Yaml.
        // This is subtly different than parsing delimiter, yaml, delimiter.
        public var body: some ParserPrinter<Input, FrontMatter> {
            "---"
            Whitespace(1, .vertical)
            PrefixUpTo("---").map(Conversions.SubstringToYaml<FrontMatter>())
            "---"
        }
    }
}

import Yams

struct YamlConversion<T: Codable>: Conversion {
    typealias Input = Data
    typealias Output = T

    init(_ type: T.Type = T.self) { }

    func apply(_ input: Data) throws -> T {
        try YAMLDecoder().decode(T.self, from: input)
    }

    func unapply(_ output: T) throws -> Data {
        try Data(YAMLEncoder().encode(output).utf8)
    }
}

extension Conversions {
    struct SubstringToYaml<T: Codable>: Conversion {
        var body: some Conversion<Substring, T> {
            Conversions.SubstringToString()
            Conversions.DataToString().inverted()
            YamlConversion<T>()
        }
    }
}

public struct MarkdownWithFrontMatterConversion<T: Codable>: Conversion {
    public typealias Input = String
    public typealias Output = MarkdownWithFrontMatter<T>

    public init() {}

    public func apply(_ input: String) throws -> MarkdownWithFrontMatter<T> {
        return try MarkdownWithFrontMatter.Parser().parse(input)
    }

    public func unapply(_ output: MarkdownWithFrontMatter<T>) throws -> String {
        var outputString: Substring = ""

        try MarkdownWithFrontMatter.Parser().print(output, into: &outputString)

        return String(outputString)
    }
}
