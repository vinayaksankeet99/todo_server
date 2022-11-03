import 'package:todo_server/dart_mongo.dart';

void main(List<String> arguments) async {
  var port = 8085;
  var server = await HttpServer.bind('192.168.1.2', port);
  var db = Db('mongodb://localhost:27017/test');
  await db.open();

  print('Connected to database');

  server.transform(HttpBodyHandler()).listen((HttpRequestBody reqBody) async {
    var request = reqBody.request;
    var response = request.response;
    switch (request.uri.path) {
      case '/':
        response.write('Hello, World!');
        await response.close();
        break;
      case '/tasks':
        TasksController(reqBody, db);
        break;
      default:
        response
          ..statusCode = HttpStatus.notFound
          ..write('Not Found');
        await response.close();
    }
  });

  print('Server listening at http://192.168.1.2:$port');
}
