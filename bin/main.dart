import 'package:todo_server/dart_mongo.dart';

Future<void> main() async {
  final server = await createServer();
  print('Server started: ${server.address} port ${server.port}');
  var db = Db('mongodb://localhost:27017/test');
  await db.open();
  print('Connected to database');
  await handleRequests(server, db);
}

Future<HttpServer> createServer() async {
  final address = '192.168.1.2';
  const port = 8085;
  return await HttpServer.bind(address, port);
}

Future<void> handleRequests(HttpServer server, Db db) async {
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
}
