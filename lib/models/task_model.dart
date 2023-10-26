class TaskModel {
  String? id;
  String? text;
  bool? isDone;

  TaskModel();

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel()
    ..id = json['id'] as String?
    ..text = json['text'] as String?
    ..isDone = json['isDone'] as bool?;

  // TaskModel.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   text = json['text'];
  //   isDone = json['isDone'];
  // }

  factory TaskModel.fromSqfliteJson(Map<String, dynamic> json) => TaskModel()
    ..id = json['id'] as String?
    ..text = json['text'] as String?
    ..isDone = (json['isDone'] as int) == 1 ? true : false;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isDone': isDone,
    };
  }

  Map<String, dynamic> toSqfliteJson() {
    return {
      'id': id,
      'text': text,
      'isDone': isDone == true ? 1 : 0,
    };
  }
}

List<TaskModel> tasksA = [
  TaskModel()
    ..id = '1'
    ..text = 'Task Item One'
    ..isDone = false,
  TaskModel()
    ..id = '2'
    ..text = 'Task Item Two'
    ..isDone = false,
  TaskModel()
    ..id = '3'
    ..text = 'Task Item Three'
    ..isDone = false,
  TaskModel()
    ..id = '4'
    ..text = 'Task Item Four'
    ..isDone = false,
  TaskModel()
    ..id = '5'
    ..text = 'Task Item Five'
    ..isDone = false,
  TaskModel()
    ..id = '6'
    ..text = 'Task Item Six'
    ..isDone = false,
  TaskModel()
    ..id = '7'
    ..text = 'Task Item Seven'
    ..isDone = false,
  TaskModel()
    ..id = '8'
    ..text = 'Task Item Eight'
    ..isDone = false,
  TaskModel()
    ..id = '9'
    ..text = 'Task Item Nine'
    ..isDone = false,
  TaskModel()
    ..id = '10'
    ..text = 'Task Item Ten'
    ..isDone = false,
];
