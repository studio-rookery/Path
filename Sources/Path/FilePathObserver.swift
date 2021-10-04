import Foundation

open class FilePathObserver: NSObject, NSFilePresenter {
    
    public let path: FilePath
    public let presentedItemOperationQueue: OperationQueue
    
    open var onChange: ((FilePath) -> Void)? {
        didSet {
            runHandler()
        }
    }
    
    public init(for path: FilePath, presentedItemOperationQueue: OperationQueue = .main) {
        self.path = path
        self.presentedItemOperationQueue = presentedItemOperationQueue
        super.init()
        NSFileCoordinator.addFilePresenter(self)
    }
    
    public var presentedItemURL: URL? {
        path.url
    }
    
    public func stop() {
        NSFileCoordinator.removeFilePresenter(self)
    }
    
    public func presentedSubitemDidChange(at url: URL) {
        runHandler()
    }
    
    public func presentedItemDidMove(to newURL: URL) {
        runHandler()
    }
    
    public func presentedItemDidChange() {
        runHandler()
    }
    
    public func presentedItemDidGain(_ version: NSFileVersion) {
        runHandler()
    }
    
    public func presentedItemDidLose(_ version: NSFileVersion) {
        runHandler()
    }
    
    public func presentedItemDidResolveConflict(_ version: NSFileVersion) {
        runHandler()
    }
    
    public func presentedSubitem(at url: URL, didGain version: NSFileVersion) {
        runHandler()
    }
    
    public func presentedSubitem(at url: URL, didLose version: NSFileVersion) {
        runHandler()
    }
    
    public func presentedSubitem(at url: URL, didResolve version: NSFileVersion) {
        runHandler()
    }
}

private extension FilePathObserver {
    
    func runHandler() {
        onChange?(path)
    }
}
