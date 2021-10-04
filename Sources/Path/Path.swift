import Foundation

public struct Path: Hashable, Comparable {
    
    public var url: URL

    public init(url: URL) {
        self.url = url
    }
    
    public init(_ string: String) {
        self = .init(url: URL(fileURLWithPath: string))
    }
    
    public var fileManager: FileManager {
        .default
    }
    
    static public func < (lhs: Path, rhs: Path) -> Bool {
        lhs.url.path < rhs.url.path
    }
}

public extension Path {
    
    static let home = Path(url: URL(fileURLWithPath: NSHomeDirectory()))
    static let documents = home + "Documents"
}

public extension Path {
    
    var path: String {
        url.path
    }
    
    var lastPathComponent: String {
        url.lastPathComponent
    }
    
    var pathExtension: String {
        url.pathExtension
    }
    
    var exists: Bool {
        fileManager.fileExists(atPath: url.path)
    }
    
    var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    
    func attributeateValue<Value>(forItemAt url: URL, forKey key: FileAttributeKey) -> Value? {
        guard let attributes = try? fileManager.attributesOfItem(atPath: url.path), let value = attributes[key] as? Value else {
            return nil
        }
        
        return value
    }
    
    var modificationDate: Date {
        attributeateValue(forItemAt: url, forKey: .modificationDate)!
    }
    
    var createionDate: Date {
        attributeateValue(forItemAt: url, forKey: .creationDate)!
    }
}

public extension Path {
    
    static func + (lhs: Path, rhs: String) -> Path {
        var new = lhs
        new += rhs
        return new
    }
    
    static func += (lhs: inout Path, rhs: String) {
        lhs.url.appendPathComponent(rhs)
    }
}

public extension Path {
    
    func createDirectory(withIntermediateDirectories createIntermediates: Bool) throws {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: createIntermediates, attributes: nil)
    }
    
    func createDirectoryIfNotExists(withIntermediateDirectories createIntermediates: Bool) throws {
        guard !exists else {
            return
        }
        try createDirectory(withIntermediateDirectories: createIntermediates)
    }
}

public extension Path {
    
    func removeIfExists() throws {
        guard exists else {
            return
        }
        
        try remove()
    }
    
    func remove() throws {
        try fileManager.removeItem(at: url)
    }
}

public extension Path {
    
    func move(to destination: Path, overwrite: Bool, withIntermediateDirectories createIntermediates: Bool) throws {
        if overwrite {
            try destination.removeIfExists()
        }
        
        if createIntermediates {
            try destination.parent.createDirectoryIfNotExists(withIntermediateDirectories: true)
        }
        
        try fileManager.moveItem(at: url, to: destination.url)
    }
    
    func copy(to destination: Path, overwrite: Bool, withIntermediateDirectories createIntermediates: Bool) throws {
        if overwrite {
            try destination.removeIfExists()
        }
        
        if createIntermediates {
            try destination.parent.createDirectoryIfNotExists(withIntermediateDirectories: true)
        }
        
        try fileManager.copyItem(at: url, to: destination.url)
    }
}

public extension Path {
    
    var parent: Path {
        Path(url: url.deletingLastPathComponent())
    }
}

public extension Path {
    
    func recursiveChildren(options: FileManager.DirectoryEnumerationOptions = []) -> [Path] {
        guard let enumrator = fileManager.enumerator(at: url, includingPropertiesForKeys: nil, options: options, errorHandler: nil) else {
            return []
        }
        
        var paths: [Path] = []
        for case let url as URL in enumrator {
            let path = Path(url: url)
            paths.append(path)
        }
        
        return paths
    }
    
    func children(options: FileManager.DirectoryEnumerationOptions = []) -> [Path] {
        guard let contents = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: options) else {
            return []
        }
        
        return contents.map(Path.init)
    }
}

public extension Collection where Element == Path {
    
    func filter(withPathExtension pathExtension: String) -> [Path] {
        filter { $0.pathExtension == pathExtension }
    }
    
    func sortedByCreationDate(ascending: Bool) -> [Path] {
        sorted { lhs, rhs in
            if ascending {
                return lhs.createionDate < rhs.createionDate
            } else {
                return lhs.createionDate > rhs.createionDate
            }
        }
    }
}
