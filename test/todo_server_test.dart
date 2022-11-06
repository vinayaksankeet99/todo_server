import 'package:test/test.dart';
import 'package:todo_server/dart_mongo.dart';

void main() {
  test('Get tasks', () async {
    final client = HttpClient();
    final request = await client.get('192.168.1.4', 8085, 'tasks?uid=1234');
    final response = await request.close();
    expect(response.statusCode, HttpStatus.ok);
  });

  test('Get tasks without uid', () async {
    final client = HttpClient();
    final request = await client.get('192.168.1.4', 8085, 'tasks');
    final response = await request.close();
    expect(response.statusCode, HttpStatus.badRequest);
  });
}
