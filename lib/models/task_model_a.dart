class TaskModelA {
  int? id;
  String? text;
  bool? isDone;

  TaskModelA();

  factory TaskModelA.fromJson(Map<String, dynamic> json) => TaskModelA()
    ..id = json['id'] as int?
    ..text = json['text'] as String?
    ..isDone = json['isDone'] as bool?;

  // TaskModel.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   text = json['text'];
  //   isDone = json['isDone'];
  // }

  factory TaskModelA.fromSqfliteJson(Map<String, dynamic> json) => TaskModelA()
    ..id = json['id'] as int?
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

// List<TaskModelA> tasksA = [
//   TaskModelA()
//     ..id = '1'
//     ..text = 'Task Item One'
//     ..isDone = false,
//   TaskModelA()
//     ..id = '2'
//     ..text = 'Task Item Two'
//     ..isDone = false,
//   TaskModelA()
//     ..id = '3'
//     ..text = 'Task Item Three'
//     ..isDone = false,
//   TaskModelA()
//     ..id = '4'
//     ..text = 'Task Item Four'
//     ..isDone = false,
//   TaskModelA()
//     ..id = '5'
//     ..text = 'Task Item Five'
//     ..isDone = false,
//   TaskModelA()
//     ..id = '6'
//     ..text = 'Task Item Six'
//     ..isDone = false,
//   TaskModelA()
//     ..id = '7'
//     ..text = 'Task Item Seven'
//     ..isDone = false,
//   TaskModelA()
//     ..id = '8'
//     ..text = 'Task Item Eight'
//     ..isDone = false,
//   TaskModelA()
//     ..id = '9'
//     ..text = 'Task Item Nine'
//     ..isDone = false,
//   TaskModelA()
//     ..id = '10'
//     ..text = 'Task Item Ten'
//     ..isDone = false,
// ];
