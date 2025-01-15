//
//  FrontmatterParsingTests.swift
//  swift-frontmatter-parsing
//
//  Created by Woodrow Melling on 1/14/25.
//

import Foundation
import XCTest
@testable import FrontmatterParsing
import Testing
import CustomDump
import Parsing

struct MarkdownWithFrontmatterTests {

    @Test
    func simpleFrontmatterRoundtripping() throws {
        struct Person: Codable, Equatable {
            var name: String
            var age: Int
        }

        let originalText = """
        ---
        name: blob
        age: 29
        ---
        """

        var text = Substring(originalText)
        let result = try Parsers.FrontMatter<Person>().parse(&text)
        #expect(result == Person(name: "blob", age: 29))
        try Parsers.FrontMatter<Person>().print(result, into: &text)
        #expect(originalText == text)
    }

    @Test
    func markdownWithFrontMatterRoundtripping() throws {
        struct PersonFrontMatter: Codable, Equatable {
            var name: String
            var age: Int
        }

        let originalText = """
        ---
        name: Blob
        age: 29
        ---
        Blob once went through parthenogenesis and created Blob Jr.
        """

        var text = Substring(originalText)
        let parserPrinter = MarkdownWithFrontMatter<PersonFrontMatter>.Parser()
        let result = try parserPrinter.parse(&text)
        #expect(
            result == MarkdownWithFrontMatter(
                frontMatter: PersonFrontMatter(name: "Blob", age: 29),
                body: "Blob once went through parthenogenesis and created Blob Jr."
            )
        )
        try parserPrinter.print(result, into: &text)
        #expect(originalText == text)
    }

    @Test
    func nilFrontMatter() throws {
        struct PersonFrontMatter: Codable, Equatable {
            var name: String
            var age: Int
        }

        let originalText = """
        Blob once went through parthenogenesis and created Blob Jr.
        """

        var text = Substring(originalText)
        let parserPrinter = MarkdownWithFrontMatter<PersonFrontMatter>.Parser()
        let result = try parserPrinter.parse(&text)
        #expect(
            result == MarkdownWithFrontMatter(
                frontMatter: nil,
                body: "Blob once went through parthenogenesis and created Blob Jr."
            )
        )
        try parserPrinter.print(result, into: &text)
        #expect(originalText == text)
    }

    @Test
    func optionalButHonestFrontMatter() throws {
        struct PersonFrontMatter: Codable, Equatable {
            var name: String
            var age: Int
        }

        let originalText = """
        ---
        name: Blob
        age: 29
        ---
        Blob once went through parthenogenesis and created Blob Jr.
        """

        var text = Substring(originalText)
        let parserPrinter = MarkdownWithFrontMatter<PersonFrontMatter>.Parser()
        let result = try parserPrinter.parse(&text)
        #expect(
            result == MarkdownWithFrontMatter(
                frontMatter: PersonFrontMatter(name: "Blob", age: 29),
                body: "Blob once went through parthenogenesis and created Blob Jr."
            )
        )
        try parserPrinter.print(result, into: &text)
        #expect(originalText == text)
    }
}

