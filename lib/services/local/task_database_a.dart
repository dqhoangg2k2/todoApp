import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:task_flutter/models/task_model_a.dart';

const String database = "taskDatabaseA.db"; // ten de tham chieu den vung nho
const String table = "task";

class TaskDatabaseA {
  Future<Database> initializeDB() async {
    String databasesPath = await getDatabasesPath();
    // join path with database name
    String path = p.join(databasesPath, database);

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $table(id INTEGER PRIMARY KEY, text TEXT, isDone INTEGER NOT NULL DEFAULT 0 )');
      },
      version: 1,
    );
  }

  // A method that retrieves all the tasks from the task table
  Future<List<TaskModelA>> getTasks() async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Query the table for all the tasks
    final List<Map<String, dynamic>> maps = await db.query(table);

    // Convert the List<Map<String, dynamic> to List<TaskModelA>
    // return List.generate(
    //   maps.length,
    //   (idx) => TaskModelA()
    //     ..id = maps[idx]['id']
    //     ..text = maps[idx]['text']
    //     ..isDone = (maps[idx]['isDone'] as int) == 0 ? false : true,
    // );

    // return maps.map((e) => TaskModelA.fromSqfliteJson(e)).toList();

    return List.generate(
      maps.length,
      (idx) => TaskModelA.fromSqfliteJson(maps[idx]),
    );
  }

  Future<TaskModelA> insertTask(TaskModelA task) async {
    // Get a reference to the database.
    final db = await initializeDB();
    final id = await db.insert(table, task.toSqfliteJson());
    return task..id = id;
  }

  Future<int> updateTask(TaskModelA task) async {
    final db = await initializeDB();

    return await db.update(table, task.toSqfliteJson(),
        where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await initializeDB();

    // return await db.delete(table, where: 'id = ?', whereArgs: [id]);
    return await db.rawDelete(
      'DELETE FROM $table WHERE id = ?',
      [id],
    );
  }
}
