# AsyncTaskPerformer

Performs lists of asynchronous tasks synchronously :arrow_right_hook:

## Features 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)

## Getting Started

[Download AsyncTaskPerformer](https://github.com/hkellaway/AsyncTaskPerformer/archive/master.zip) and perform a `pod install` on the included `Demo` app to see AsyncTaskPerformer in action

### Swift Version

AsyncTaskPerformer is currently compatible with Swift 4.2.

### Installation with CocoaPods

```ruby
pod 'AsyncTaskPerformer', :git => 'https://github.com/hkellaway/AsyncTaskPerformer.git', :tag => '0.1.0'
```

### Installation with Carthage

```
github "hkellaway/AsyncTaskPerformer"
```

## Usage

AsyncTaskPerformer takes lists of asynchronous tasks and processes them in order. It can do so for multiple uses cases:

* The list of asynchronous tasks should be processed in order with a single completion point - but without concern for if errors occur in any nor require a typed result (Use [SynchronousDispatchGroup](#SynchronousDispatchGroup))
* The list of asynchronous tasks should be processed in order, report their result using the same type, and have a single completion point - the completion point must report the result of attempting each task in order, either with an error or the final typed result (Use [SynchronousOperationQueue](#SynchronousOperationQueue))

## SynchronousDispatchGroup

`SynchronousDispatchGroup` uses a `DispatchGroup` to synchronize its list of asynchrnous tasks. It is better used for tasks that don't need to be typed and don't need to halt execution if an error occurs. Let's look at an example of usage.

First, create tasks that conform to `AsyncTask`. Let's imagine a task that prints out "Hello World" - we'll give our tasks an `id` so we can confirm they're processing in order.

``` swift
struct SayHelloTask: AsyncTask {
    
    let id: Int
    
    func execute(completion: @escaping () -> Void) {
        print("Hello World \(id)")
        completion()
    }
    
}

```

The critical aspect of an `AsyncTask` is that it independently knows how ot `execute` a piece of work.

Next, create a `SynchronousDispatchGroup` and give it a list of `AsyncTasks`s to perform, as well as a single completion point.


``` swift
let tasks: [AsyncTask] = [SayHelloTask(id: 1), SayHelloTask(id: 2), SayHelloTask(id: 3) ]
let synchronousDispatchGroup = SynchronousDispatchGroup()

synchronousDispatchGroup.executeTasks(tasks) {
    print("Goodbye")
}

```

The output from this will be:

```
Hello World 1
Hello World 2
Hello World 3
Goodbye
```


### SynchronousOperationQueue

`SynchronousOperationQueue` uses an `OperationQueue` to synchronize its list of asynchrnous tasks. It is better used for tasks that have a specific type which the tasks perform work on in-order. For example, in an e-commerce application we might need to remove Items from the Bag one-by-one and report the state of the Bag after each successful removal.

If an error is encountered in the midst of processing the tasks, the rest of the tasks are cancelled and the completion is called early.

Let's imagine we have an `api` that, when given an `itemID` will `removeFromBag` the provided `Item` and report back the resulting state of the `Bag` (or, an error if the Item was not present in the Bag).

First, create an operation that inherits from `AsyncOperationWithCompletion`.

``` swift
final class RemoveItemFromBagOperation: AsyncOperationWithCompletion<Bag> {

    let itemID: Int
    let api: ECommAPI
    
    init(id: Int, api: ECommAPI) {
        self.id = id
        self.api = api
    }
    
    override func main() {
        api.removeFromBag(item: itemID) { [weak self] (updatedBag, error) in
            self?.completion?(updatedBag, error)
            self?.finish()
        }
    }
    
}

```

The critical aspect of `AsyncOperationWithCompletion` is that it calls its own `completion` closure then calls `finish()`.

Next, create a `SynchronousOperationQueue` and give it a list of tasks to process - as well as a starting value and a single completion point.

``` swift
let currentBag = Bag(items: [Item(id: 1), Item(id: 2), Item(id: 3), Item(id: 4)])
let itemsToRemove = [2, 4]
let operations = itemsToRemove.map { RemoveItemFromBagOperation(itemID: $0, api: api) }
let synchronousOperationQueue = SynchronousOperationQueue(defaultValue: currentBag)

synchronousOperationQueue.executeOperations(operations) { (finalBag, error) in
    if let error = error {
        print(":(")
    } else {
        print("Updated Bag: " + finalBag)
    }
}

```

The result from this, if all API calls completed successfully, would be the Bag updated such that Item 2 and Item 4 have been removed.

## Credits

AsyncTaskPerformer was created by [Harlan Kellaway](http://harlankellaway.com).

## License

AsyncTaskPerformer is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/hkellaway/AsyncTaskPerformer/master/LICENSE) file for more info.
