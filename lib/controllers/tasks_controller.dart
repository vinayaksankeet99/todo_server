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
        await handleGet();
        break;
      case 'POST':
        await handlePost();
        break;
      case 'PUT':
        await handlePut();
        break;
      case 'DELETE':
        await handleDelete();
        break;
      default:
        await returnError(message: 'Method Not allowed', statusCode: 405);
    }

    await _req.response.close();
  }

  Future<void> returnError(
      {required String message, required int statusCode}) async {
    _req.response.statusCode = statusCode;
    _req.response.reasonPhrase = message;
    await _req.response.close();
  }

  // CRUD operations

  Future<void> handleGet() async {
    if (_req.uri.queryParameters['uid'] == null) {
      await returnError(
          message: 'Query parameter uid missing', statusCode: 400);
    } else {
      final result = await _store
          .find(where.eq('user', _req.uri.queryParameters['uid']))
          .toList();
      final converter = result.map((e) => jsonEncode(e)).toList();
      _req.response.write(converter);
    }
  }

  Future<void> handlePost() async {
    if (_reqBody.body['title'] == null) {
      await returnError(message: 'Task must have a name', statusCode: 400);
    } else if (_reqBody.body['user'] == null) {
      await returnError(message: 'Task must have a user id', statusCode: 400);
    } else {
      final result = await _store.insertOne(_reqBody.body);
      if (result.hasWriteErrors) {
        await returnError(message: result.errmsg ?? '', statusCode: 500);
      } else {
        _req.response.write('success');
      }
    }
  }

  Future<void> handlePut() async {
    var id = _req.uri.queryParameters['id'];

    if (id == null) {
      await returnError(message: 'Query parameter id missing', statusCode: 400);
    } else if (_reqBody.body['title'] == null) {
      await returnError(message: 'Task must have a name', statusCode: 400);
    } else if (_reqBody.body['user'] == null) {
      await returnError(message: 'Task must have a user id', statusCode: 400);
    } else {
      var itemToPut = await _store.findOne(where.eq('_id', ObjectId.parse(id)));
      if (itemToPut == null) {
        await _store.insertOne(_reqBody.body);
      } else {
        await _store.update(itemToPut, _reqBody.body);
      }
      _req.response.write('success');
    }
  }

  Future<void> handleDelete() async {
    var id = _req.uri.queryParameters['id'];
    if (id == null) {
      await returnError(message: 'Query parameter id missing', statusCode: 500);
    } else {
      var itemToDelete =
          await _store.findOne(where.eq('_id', ObjectId.parse(id)));
      if (itemToDelete != null) {
        _req.response.write(await _store.remove(itemToDelete));
        _req.response.write('success');
      }
    }
  }
}
