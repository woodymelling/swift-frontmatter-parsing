# FrontmatterParsing

A concise Swift µ-package for parsing and printing Markdown files with YAML front matter. Built atop [swift-parsing](https://github.com/pointfreeco/swift-parsing) for the parsing layer and [Yams](https://github.com/jpsim/Yams) for YAML encoding/decoding. It supports **optional** front matter, an **optional** Markdown body, and provides a clean round-trip conversion—Markdown to Swift object and back again.

## Installation

<details>
<summary>Swift Package Manager</summary>

1. Add the package to your `Package.swift`:

   ```swift
   dependencies: [
       .package(url: "https://github.com/woodymelling/swift-frontmatter-parsing.git", from: "0.1.0")
   ]
   ```

2. Add the product to your target dependencies:

   ```swift
   .target(
       name: "YourTarget",
       dependencies: [
           .product(name: "FrontmatterParsing", package: "swift-frontmatter-parsing")
       ]
   )
   ```
</details>

## Usage

```swift
import FrontmatterParsing

// 1. Define a Codable front matter model
struct MyFrontMatter: Codable {
    let title: String
    let tags: [String]?
}

// 2. Your Markdown input (front matter + body)
let markdownInput = """
---
title: My Document
tags:
  - swift
  - example
---
# Hello World
This is my document.
"""

// 3. Parse it
let conversion = MarkdownWithFrontMatterConversion<MyFrontMatter>()
do {
    let parsed = try conversion.apply(markdownInput)
    print(parsed.frontMatter?.title)  // "My Document"
    print(parsed.body)                // "# Hello World\nThis is my document."
    
    // 4. Convert back to Markdown
    let roundTrip = try conversion.unapply(parsed)
    print(roundTrip)
} catch {
    print("Failed to parse: \(error)")
}
```

## License

Released under the [MIT License](LICENSE).
