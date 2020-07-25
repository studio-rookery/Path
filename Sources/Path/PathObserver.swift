import Foundation

open class PathObserver: NSObject, NSFilePresenter {
    
    public let path: Path
    public let presentedItemOperationQueue: OperationQueue
    
    open var onChange: ((Path) -> Void)?
    
    public init(for path: Path, presentedItemOperationQueue: OperationQueue = .main) {
        self.path = path
        self.presentedItemOperationQueue = presentedItemOperationQueue
        super.init()
        NSFileCoordinator.addFilePresenter(self)
    }
    
    public var presentedItemURL: URL? {
        path.url
    }
    
    func stop() {
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

private extension PathObserver {
    
    func runHandler() {
        onChange?(path)
    }
}
