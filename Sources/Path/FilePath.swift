import Foundation

public struct FilePath: Hashable, Comparable {
    
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
    
    static public func < (lhs: FilePath, rhs: FilePath) -> Bool {
        lhs.url.path < rhs.url.path
    }
}

public extension FilePath {
    
    static let home = FilePath(url: URL(fileURLWithPath: NSHomeDirectory()))
    static let documents = home + "Documents"
}

public extension FilePath {
    
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
    
    func attributeateValue<Value>(forKey key: FileAttributeKey) -> Value? {
        guard let attributes = try? fileManager.attributesOfItem(atPath: url.path), let value = attributes[key] as? Value else {
            return nil
        }
        
        return value
    }
    
    var modificationDate: Date {
        attributeateValue(forKey: .modificationDate)!
    }
    
    var createionDate: Date {
        attributeateValue(forKey: .creationDate)!
    }
}

public extension FilePath {
    
    static func + (lhs: FilePath, rhs: String) -> FilePath {
        var new = lhs
        new += rhs
        return new
    }
    
    static func += (lhs: inout FilePath, rhs: String) {
        lhs.url.appendPathComponent(rhs)
    }
}

public extension FilePath {
    
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

public extension FilePath {
    
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

public extension FilePath {
    
    func move(to destination: FilePath, overwrite: Bool, withIntermediateDirectories createIntermediates: Bool) throws {
        if overwrite {
            try destination.removeIfExists()
        }
        
        if createIntermediates {
            try destination.parent.createDirectoryIfNotExists(withIntermediateDirectories: true)
        }
        
        try fileManager.moveItem(at: url, to: destination.url)
    }
    
    func copy(to destination: FilePath, overwrite: Bool, withIntermediateDirectories createIntermediates: Bool) throws {
        if overwrite {
            try destination.removeIfExists()
        }
        
        if createIntermediates {
            try destination.parent.createDirectoryIfNotExists(withIntermediateDirectories: true)
        }
        
        try fileManager.copyItem(at: url, to: destination.url)
    }
}

public extension FilePath {
    
    var parent: FilePath {
        FilePath(url: url.deletingLastPathComponent())
    }
}

public extension FilePath {
    
    func recursiveChildren(options: FileManager.DirectoryEnumerationOptions = []) -> [FilePath] {
        guard let enumrator = fileManager.enumerator(at: url, includingPropertiesForKeys: nil, options: options, errorHandler: nil) else {
            return []
        }
        
        var paths: [FilePath] = []
        for case let url as URL in enumrator {
            let path = FilePath(url: url)
            paths.append(path)
        }
        
        return paths
    }
    
    func children(options: FileManager.DirectoryEnumerationOptions = []) -> [FilePath] {
        guard let contents = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: options) else {
            return []
        }
        
        return contents.map(FilePath.init)
    }
}

public extension Collection where Element == FilePath {
    
    func filter(withPathExtension pathExtension: String) -> [FilePath] {
        filter { $0.pathExtension == pathExtension }
    }
    
    func sortedByCreationDate(ascending: Bool) -> [FilePath] {
        sorted { lhs, rhs in
            if ascending {
                return lhs.createionDate < rhs.createionDate
            } else {
                return lhs.createionDate > rhs.createionDate
            }
        }
    }
}
