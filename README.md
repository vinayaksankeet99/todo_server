# Dart Todo server app 

This project is for creating REST API using dart, mongoDB and httpServer

# Run the project

dart bin/main.dart

# Packages used
> mongo_dart: For making CRUD operations on database. Mongo is highly scalable, efficient and and simple as one collection holds different documents
>http_server: For local deployment / dev server . It hosts a local http server 

# Testing
Basic API unit tests performed in test/todo_server_test.dart
to run --> dart test test/todo_server_test.dart

# API documentation

Dart REST API 

Endpoint - 'baseUrl/tasks'

    > GET '/tasks?uid=user_id'
        response: [
            {
                'title': String (* required)
                'date': int (optional)
                'user': String (*required)
                'done': bool (default false)
            }
        ]

     > POST '/tasks'   
        body:  
            {
                'title': String (* required)
                'date': int (optional)
                'user': String (*required)
                'done': bool (default false)
            }

        response: 'success'

     > PUT '/tasks?id=task_id'
        body:  
            {
                'title': String (* required)
                'date': int (optional)
                'user': String (*required)
                'done': bool (default false)
            }
        response: 'success'

     > DELETE '/tasks?id=task_id'
        response: 'success'

# Error codes

405 - Method not allowed
500 - Database failure
400 - Bad request 