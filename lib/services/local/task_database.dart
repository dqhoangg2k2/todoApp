import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:task_flutter/models/task_model.dart';

const String database = "taskDatabase.db"; // ten de tham chieu den vung nho
const String table = "task";

class TaskDatabase {
  Future<Database> initializeDB() async {
    String databasesPath = await getDatabasesPath();
    // join path with database name
    String path = p.join(databasesPath, database);

    return openDatabase(      // phần tạo bảng
      path,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $table(id TEXT, text TEXT, isDone INTEGER NOT NULL DEFAULT 0 )');
      },
      version: 1,
    );
  }

  // A method that retrieves all the tasks from the task table
  Future<List<TaskModel>> getTasks() async {  // list ko thể null vì trong bảng có dữ liệu  , nên ko thể là Future<List<TaskModel?>>
    // Get a reference to the database.
    final db = await initializeDB();
    // nếu chưa có tạo mới , có rồi truy xuất đến : final db = await initializeBD :  ( để tương tác vs csdl ) , 
    // dùng code tạo bảng , ko cần tự vẽ databasse


    // Query the table for all the tasks
    final List<Map<String, dynamic>> maps = await db.query(table);
   //truy xuất rồi lấy bảng về final List<Map ... (table)


    // Convert the List<Map<String, dynamic> to List<TaskModel>
    // return List.generate(
    //   maps.length,
    //   (idx) => TaskModel()
    //     ..id = maps[idx]['id']
    //     ..text = maps[idx]['text']
    //     ..isDone = (maps[idx]['isDone'] as int) == 0 ? false : true,
    // );

    // return maps.map((e) => TaskModel.fromSqfliteJson(e)).toList();

    return List.generate(
      maps.length,
      (idx) => TaskModel.fromSqfliteJson(maps[idx]),
    );
  }

  Future<void> insertTask(TaskModel task) async {
    // Get a reference to the database.
    final db = await initializeDB();
    db.insert(table, task.toSqfliteJson());
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await initializeDB();

    db.update(table, task.toSqfliteJson(),
        where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(String id) async {
    final db = await initializeDB();

    // db.delete(table, where: 'id = ?', whereArgs: [id]);
    db.rawDelete(
      'DELETE FROM $table WHERE id = ?',
      [id],
    );
  }
}
