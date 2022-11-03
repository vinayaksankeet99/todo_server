import 'dart:convert';
import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:mongo_dart/mongo_dart.dart';

class TasksController {
  TasksController(this._reqBody, Db db)
      : _req = _reqBody.request,
        _store = db.collection('tasks') {
    handle();
  }

  final HttpRequestBody _reqBody;

  final HttpRequest _req;
  final DbCollection _store;

  void handle() async {
    switch (_req.method) {
      case 'GET':
      case 'POST':
      case 'PUT':
      case 'DELETE':
      default:
        _req.response.statusCode = 405;
    }

    await _req.response.close();
  }
}
