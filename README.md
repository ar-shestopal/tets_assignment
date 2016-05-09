# Test Assignment with errors
Mysterious Ruby Backend.


### Database
`rake db:seed`

### Authorization (HTTP Basic authentication)
There are 2 users (admin and regular user), guests without authorization.

##### Admin:
```
Base64.encode64('admin@test.com:password')
=> "YWRtaW5AdGVzdC5jb206cGFzc3dvcmQ=\n"
```
##### Regular User:
```
Base64.encode64('user@test.com:password')
=> "dXNlckB0ZXN0LmNvbTpwYXNzd29yZA==\n"
```

Then put encoded string to the header of the request.
```
-H "Authorization: Basic dXNlckB0ZXN0LmNvbTpwYXNzd29yZA==\n"
```


### Endpoints
##### Users
`/api/users`

##### Articles
`/api/articles`

##### Comments
`/api/comments`


### Versioning
To switch between versions, you can by adding to header number of version (by default is `version 1`):
```
-H "Accept: application/mytest; version=1"
```
NOTE: before using another version need to add `routes` for it.
