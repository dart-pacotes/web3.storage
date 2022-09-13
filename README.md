# web3.storage

Port of web3.storage SDK in Dart

Live demo: https://bafybeigtf5gnvr5fiohg7enum736ia6tteziirouf4reeqx2zgazb24bki.ipfs.dweb.link

## How to use

Before using the package, make sure you have an account in Web3.Storage and an [API Token](https://web3.storage/tokens/). Uploading a file to Web3.Storage is as simple as:

```dart
// You can grab an API Token here: https://web3.storage/tokens/
final String apiToken = '<web3.storage_api_token>';

final web3Storage = withApiToken(apiToken);

// Create file reference model of what will be uploaded to Web3.storage
final file = RawFile(
    name: 'hello',
    extension: 'txt',
    data: Uint8List.fromList(
        utf8.encode('Hello world'),
    ),
);

// Upload it
final result = await web3Storage.upload(file: file);

// Tadaaaaam! It should print your Web3 file IPFS CID
print(result);
```

## Features

So far the package is capable of:

- Uploading a file
- Retrieving information of a file
- Downloding a file
- Listing files using filters

Web3.Storage API errors are also typed in the package, providing you an easy way to identify issues when a request fails.

## Missing features

No CAR endpoint has been implemented yet, meaning you can not upload or retrieve `CAR` files. The upload status endpoint has also not been implemented yet.

## Side Effects

Powered by Dart null sound + [`dartz`](https://pub.dev/packages/dartz) 
monads, this package is free of null issues and side effects. This is to 
prevent the throw of any exception that may not be known and caught by 
developers, and to make sure that information is consistent by contract.

---

### Bugs and Contributions

Found any bug (including typos) in the package? Do you have any suggestion 
or feature to include for future releases? Please create an issue via 
GitHub in order to track each contribution. Also, pull requests are very 
welcome!
