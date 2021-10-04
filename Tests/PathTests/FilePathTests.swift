import XCTest
@testable import Path

final class FilePathTests: XCTestCase {
    
    let fixture = FilePath(#file).parent + "Fixture"
    
    override func setUp() {
        super.setUp()
        
        precondition(FileManager.default.changeCurrentDirectoryPath(fixture.path))
    }
    
    func testExample() {
        
    }
    
    func testChildren() {
        let result = fixture.children().sorted()
        let expected = [
            fixture + "dir",
            fixture + "text1.txt",
            fixture + "text2.txt",
            fixture + "text3.txt",
        ]
        XCTAssertEqual(result, expected)
    }
    
    func testRecursiveChildren() {
        let result = fixture.recursiveChildren().sorted()
        let expected = [
            fixture + "dir",
            fixture + "dir/text4.txt",
            fixture + "dir/text5.txt",
            fixture + "text1.txt",
            fixture + "text2.txt",
            fixture + "text3.txt",
        ]
        XCTAssertEqual(result, expected)
    }
    
    func testFilterWithPathExtension() {
        let result = fixture.children().filter(withPathExtension: "txt").sorted()
        let expected = [
            fixture + "text1.txt",
            fixture + "text2.txt",
            fixture + "text3.txt",
        ]
        XCTAssertEqual(result, expected)
    }
    
    func testExists() {
        XCTAssertEqual(fixture.exists, true)
        XCTAssertEqual((fixture + "hoge").exists, false)
    }
    
    func testisDirectory() {
        XCTAssertEqual(fixture.isDirectory, true)
        XCTAssertEqual((fixture + "text1.text").isDirectory, false)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
