# Path

## Usage

```swift
let path = Path("dir")
```

### Create directory

```swift
try path.createDirectory(withIntermediateDirectories: true)
try path.createDirectoryIfNotExists(withIntermediateDirectories: true)
```

### Remove

```swift
try path.remove()
try path.removeIfExists()
```

### Copy

```swift
try path.move(to: destination, overwrite: true, withIntermediateDirectories: true)
```

### Move

```swift
try path.copy(to: destination, overwrite: true, withIntermediateDirectories: true)
```

### Parent

```swift
let parent = path.parent
```

### Children

```swift
let children = path.children()
let recursiveChildren = path.recursiveChildren()
```

### Observe

```swift
let pathObserver = PathObserver(for: .documents)

pathObserver.onChange = { path in
    print(path)
}
```
