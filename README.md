# RxNetworkApiClient


## Requirements
  - RxSwift
  - SwiftyJson
  - `Codable` mark is required for all Entities.
  - Need to set default `ApiEndpoint.baseEndpoint` before sending requests or init new ApiClient with with `defaultInstance(host:)`

## Example 

```swift

class TodoItem: Codable{
    var title: String? = nil
}


let apiClient = ApiClientImp.defaultInstance("https://jsonplaceholder.typicode.com")
let request: ApiRequest<TodoItem> = .request(path: "/todos", method: .get)

apiClient.execute(request)
    .subscribe(onSuccess: { (items: [TodoItem])
        // use result
    })

```

# Features
## Interceptors
For request modification before sending and additional response handling.

Builtin Logging interceptor result example:
```
>>> https://jsonplaceholder.typicode.com/todos [GET]

<<< https://jsonplaceholder.typicode.com/todos
<<< Status code: (200) 👌
<<< Body: Body: [
  {
    "userId": 1,
    "id": 1,
    "title": "delectus aut autem",
    "completed": false
  },
  ...
```

Example for custom OAuth2 interceptor:

```swift
import Foundation
import RxNetworkApiClient
import RxSwift


class AuthInterceptor: Interceptor {

    private let settings: Settings


    init(_ settings: Settings) {
        self.settings = settings
    }

    func prepare<T: Codable>(request: ApiRequest<T>) {
        if let accessToken = settings.authCode?.accessToken {
            let hasAuthHeader = request.headers?.contains(where: { header in
                header.key == "Authentication"
            })

            if hasAuthHeader != true {
                if request.headers == nil {
                    request.headers = []
                }
                request.headers!.append(Header("Authentication", accessToken))
            }
        }
    }

    func handle<T: Codable>(request: ApiRequest<T>, response: NetworkResponse) {
        // empty
    }
}
````

## Custom Http Body converters

Mark Entity for sending with `JsonBodyConvertible` protocol
```swift
struct NoteEntity: JsonBodyConvertible {

    var date: Date
    var text: String
    var warning_level: Int
}


let note = NoteEntity(date: Date(), text: "note text", warning_level: Int.max)
let request: ApiRequest<JSON> = .request(path: "/todo/add",
                                         method: .post,
                                         body: note)

apiClient.execute(request: request).subscribe()
```
Show in output
```
>>> https://jsonplaceholder.typicode.comtodo/add [POST] Parameters: {"date":558022549.47259104,"text":"note text","warning_level":9223372036854775807}
```

## Custom Response Handler

Before returning result to subscriber response is stepping over stack of ResponseHandler's



## File uploading

```swift

let imgs = ["https://pp.userapi.com/c834302/v834302737/278d7/DoAiIaCb5hY.jpg?ava=1",
                "https://2static1.fjcdn.com/comments/When+i+was+a+small+kid+and+tried+smoking+i+_57ab9cf4d3afaa9daba047a508dc4f2f.jpg"]
            .compactMap { URL(string: $0)! }
            .compactMap { try! Data(contentsOf: $0) }

let files = [UploadFile(name: "file 1.jpg", data: imgs[0], mimeType: "jpg"),
                  UploadFile(name: "file 2.jpg", data: imgs[1], mimeType: "jpg")]

let request: ApiRequest<JSON> = .request("/file/add", method: .post, files: files)

apiClient.execute(request: request).subscribe()
```

## Full list of available operations for request
```swift
static public func request<ResponseType: Codable>(
            path: String? = nil,
            method: HttpMethod,
            endpoint: ApiEndpoint = ApiEndpoint.baseEndpoint,
            headers: [Header]? = nil,
            formData: FormDataFields? = nil,
            files: [UploadFile]? = nil,
            body: BodyConvertible? = nil,
            query: QueryField...) -> ApiRequest<ResponseType> {
```

# Installation

RxNetworkApiClient is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxNetworkApiClient'
```

## Author

starmel, slava.kornienko16@gmail.com

## License

RxNetworkApiClient is available under the MIT license. See the LICENSE file for more info.
