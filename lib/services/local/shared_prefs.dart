import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flutter/models/task_model.dart';

class SharedPrefs {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final String keyTask = 'keyTask';

  Future<List<TaskModel>?> getTasks() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString(keyTask);
    if (data == null) return null;

    print('object $data');

    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;

    print('object $maps');

    return maps.map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<void> addTasks(List<TaskModel> tasks) async {
    final maps = tasks.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString(keyTask, jsonEncode(maps));
  }
}
