import Foundation

public extension FilePath {
    
    var isUbiquitousItem: Bool {
        fileManager.isUbiquitousItem(at: url)
    }
    
    func startDownloading(_ completionHandler: @escaping (Result<Void, Error>) -> Void) {
        do {
            try fileManager.startDownloadingUbiquitousItem(at: url)
        } catch {
            completionHandler(.failure(error))
            return
        }
        
        let queue = OperationQueue.main
        
        let query = NSMetadataQuery()
        query.operationQueue = queue
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope, NSMetadataQueryUbiquitousDataScope, NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope]
        query.predicate = NSPredicate.init(format: "%K = %@", NSMetadataItemPathKey, url.path)
        
        let notificationCenter = NotificationCenter.default
        
        let names: [NSNotification.Name] = [
            .NSMetadataQueryDidStartGathering,
            .NSMetadataQueryDidFinishGathering,
            .NSMetadataQueryDidUpdate,
            .NSMetadataQueryGatheringProgress
        ]
                
        var observations: [NSObjectProtocol] = []
        
        func stopObserve() {
            observations.forEach(notificationCenter.removeObserver)
            query.stop()
        }
        
        observations = names.map { name in
            notificationCenter.addObserver(forName: name, object: query, queue: queue) { _ in
                let metaDataItem = query.results.compactMap { $0 as? NSMetadataItem }.first
                
                switch metaDataItem?.downloadingState {
                case .success(.downloaded):
                    completionHandler(.success(()))
                    stopObserve()
                case .failure(let error):
                    completionHandler(.failure(error))
                    stopObserve()
                case .success(.downloading), nil:
                    break
                }
            }
        }
        
        query.start()
    }
}

private extension NSMetadataItem {
    
    enum DownloadingState {
        case downloaded
        case downloading
    }
    
    var downloadingState: Result<DownloadingState, Error> {
        if let error = value(forAttribute: NSMetadataUbiquitousItemDownloadingErrorKey) as? NSError {
            return .failure(error)
        }
        
        if let status = value(forAttribute: NSMetadataUbiquitousItemDownloadingStatusKey) as? String, status == NSMetadataUbiquitousItemDownloadingStatusCurrent {
            return .success(.downloaded)
        } else {
            return .success(.downloading)
        }
    }
}
